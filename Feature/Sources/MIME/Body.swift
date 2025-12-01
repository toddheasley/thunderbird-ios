import Foundation

/// Body described in [RFC 2045](https://www.rfc-editor.org/rfc/rfc2045#section-2.6)
public struct Body {
    public let contentType: ContentType
    public let parts: [Part]

    public var boundary: Boundary? { contentType.boundary }

    public var data: Data {
        fatalError()
    }

    public var headers: [String: String] {
        [
            "MIME-Version": "1.0"
        ]
    }

    public init(_ parts: [Part], contentType: ContentType = .multipart(.mixed)) throws {
        switch contentType {
        case .multipart: break
        default: break
        }
        self.contentType = contentType
        self.parts = parts
    }
}
