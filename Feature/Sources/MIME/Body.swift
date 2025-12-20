import Foundation

/// Multipart body element described in [RFC 2045](https://www.rfc-editor.org/rfc/rfc2045#section-2.6)
public struct Body: CustomStringConvertible, RawRepresentable, Sendable {
    public let contentTransferEncoding: ContentTransferEncoding?
    public let contentType: ContentType  // Body encoding is always ASCII
    public let parts: [Part]

    public var headers: [String: String] {
        var headers: [String: String] = [:]
        if contentType.isMultipart {
            headers["MIME-Version"] = "1.0"
        }
        if let contentTransferEncoding {
            headers["Content-Transfer-Encoding"] = contentTransferEncoding.description
        }
        headers["Content-Type"] = contentType.description
        return headers
    }

    public init(parts: [Part], contentType: ContentType = .multipart(.mixed), encoding: ContentTransferEncoding? = nil) throws {
        guard !parts.isEmpty else {
            throw MIMEError.dataNotFound
        }
        if parts.count == 1, parts[0].contentType == .text(.plain, .ascii) {
            contentTransferEncoding = parts[0].contentTransferEncoding
            self.contentType = .text(.plain, .ascii)
        } else if contentType.isMultipart {
            contentTransferEncoding = encoding
            self.contentType = contentType
        } else {
            throw MIMEError.contentTypeNotPossible(contentType)
        }
        self.parts = parts
    }

    /// Read headers and decode body from raw ASCII blob.
    public init(_ description: String) throws {
        let part: Part = try Part(description)
        switch part.contentType {
        case .multipart:
            let parts: [Part] = try part.parts
            try self.init(parts: parts, contentType: part.contentType, encoding: part.contentTransferEncoding)
        case .text(let subtype, let charset):
            guard subtype == .plain, charset == .ascii else {
                throw MIMEError.contentTypeNotPossible(part.contentType)
            }
            try self.init(parts: [part], contentType: .text(.plain, .ascii))
        default:
            throw MIMEError.contentTypeNotPossible(part.contentType)
        }
    }

    /// Read headers and decode body from raw ASCII data.
    public init(_ description: Data) throws {
        guard let description: String = String(data: description, encoding: .ascii) else {
            throw MIMEError.dataNotDecoded(description, encoding: .ascii)
        }
        try self.init(description)
    }

    // MARK: CustomStringConvertible
    public var description: String { String(data: rawValue, encoding: .ascii)! }

    // MARK: RawRepresentable
    public var rawValue: Data {
        var data: Data = Data()
        for key in headers.keys {
            data.append("\(key): \(headers[key]!)\(crlf)".data(using: .ascii)!)
        }
        switch contentType {
        case .multipart(_, let boundary):
            data.append(try! parts.data(using: boundary))
        case .text:
            data.append(crlf.data(using: .ascii)!)
            data.append(parts[0].data)
            data.append(crlf.data(using: .ascii)!)
        default:
            fatalError(MIMEError.contentTypeNotPossible(contentType).description)
        }
        return data
    }

    public init?(rawValue: Data) {
        try? self.init(rawValue)
    }
}

extension Body {
    public static var empty: Self {
        try! Self(
            parts: [
                try! Part(data: "".data(using: .ascii)!, contentType: .text(.plain, .ascii))
            ], contentType: .text(.plain, .ascii))
    }

    public var isEmpty: Bool {
        parts.count == 1 && (String(data: parts[0].data, encoding: .ascii) ?? "").isEmpty
    }
}
