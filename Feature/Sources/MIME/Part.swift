import Foundation

/// Body part described in [RFC 2045](https://www.rfc-editor.org/rfc/rfc2045#section-2.5)
public struct Part: CustomStringConvertible, RawRepresentable {

    /// Instruct mail client to display decoded body part inline, in message, or link as an attachment. Optionally include file name and other metadata for source file.
    public let contentDisposition: ContentDisposition
    public let contentTransferEncoding: ContentTransferEncoding
    public let contentType: ContentType

    /// The actual part content, encoded as an ASCII string using the transfer encoding specified in the part header; typically base64 or quoted-printable
    public let data: Data

    public var headers: [String: String] {
        [
            "Content-Disposition": contentDisposition.description,
            "Content-Transfer-Encoding": contentTransferEncoding.description,
            "Content-Type": contentType.description
        ]
    }

    /// Read headers and decode body part from raw ASCII blob.
    public init(_ description: String) throws {
        let components: [String] = description.replacingOccurrences(of: crlf, with: "\n").components(separatedBy: "\n")
        guard let index: Int = components.firstIndex(of: "") else {
            throw MIMEError.dataNotFound
        }
        var contentDisposition: ContentDisposition?
        var contentTransferEncoding: ContentTransferEncoding?
        var contentType: ContentType?
        for header in components[0..<index] {
            let header: [String] = header.components(separatedBy: ": ").map { $0.trimmed() }
            guard header.count == 2 else { continue }
            switch header[0] {
            case "Content-Disposition":
                contentDisposition = ContentDisposition(rawValue: header[1])
            case "Content-Transfer-Encoding":
                contentTransferEncoding = ContentTransferEncoding(rawValue: header[1])
            case "Content-Type":
                contentType = ContentType(rawValue: header[1])
            default:
                continue
            }
        }
        guard let data: Data = components.dropFirst(index).joined(separator: "\n").trimmed().data(using: .ascii),
            let contentDisposition, let contentTransferEncoding, let contentType
        else {
            throw MIMEError.dataNotFound
        }
        self.init(
            data: data,
            contentDisposition: contentDisposition,
            contentTransferEncoding: contentTransferEncoding,
            contentType: contentType
        )
    }

    public init(_ description: Data) throws {
        guard let description: String = String(data: description, encoding: .ascii) else {
            throw MIMEError.dataNotDecoded(description, encoding: .ascii)
        }
        try self.init(description)
    }

    /// Use memberwise initializer to encode new parts.
    public init(
        data: Data,
        contentDisposition: ContentDisposition,
        contentTransferEncoding: ContentTransferEncoding,
        contentType: ContentType
    ) {
        self.contentDisposition = contentDisposition
        self.contentTransferEncoding = contentTransferEncoding
        self.contentType = contentType
        self.data = data
    }

    // MARK: CustomStringConvertible
    public var description: String { String(data: rawValue, encoding: .ascii)! }

    // MARK: RawRepresentable
    public var rawValue: Data {
        var data: Data = Data()
        for key in headers.keys.sorted() {
            data.append("\(key): \(headers[key]!)\(crlf)".data(using: .ascii)!)
        }
        data.append(crlf.data(using: .ascii)!)
        data.append(self.data + crlf.data(using: .ascii)!)
        data.append(crlf.data(using: .ascii)!)
        return data
    }

    public init?(rawValue: Data) {
        try? self.init(rawValue)
    }
}
