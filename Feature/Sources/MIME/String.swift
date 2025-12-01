import Foundation

extension String {
    /// Line is defined as a sequence of octets separated by a [CRLF](https://developer.mozilla.org/en-US/docs/Glossary/CRLF)
    /// Described in [RFC 2045](https://www.rfc-editor.org/rfc/rfc2045#section-2.10)
    public static var crlf: Self { "\r\n" }

    /// ASCII-compatible UUID string separator
    public static var separator: Self { "-" }

    /// ASCII representation, if `String` is ASCII
    public var ascii: Self? {
        guard let data: Data = data(using: .ascii) else {
            return nil
        }
        return Self(data: data, encoding: .ascii)
    }

    /// Decode quoted-printable data.
    public init(quotedPrintable data: Data) throws {
        guard
            let string: String = String(data: data, encoding: .ascii)?
                .replacingOccurrences(of: "=\r\n", with: "")
                .replacingOccurrences(of: "=\n", with: "")
                .replacingOccurrences(of: "%", with: "%25")
                .replacingOccurrences(of: "=", with: "%")
                .removingPercentEncoding
        else {
            throw MIMEError.dataNotQuotedPrintable
        }
        self = string
    }

    func removing(_ characters: [Character]) -> Self {
        var string: Self = "\(self)"
        for character in characters {
            string = string.replacingOccurrences(of: "\(character)", with: "")
        }
        return string
    }

    func trimmed() -> Self {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension [Character] {
    static var quotes: Self { ["\"", "'"] }
}

var crlf: String { .crlf }
