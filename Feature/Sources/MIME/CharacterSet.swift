import Foundation

/// Character encoding described in [RFC 2045](https://www.rfc-editor.org/rfc/rfc2045#section-2.2)
public struct CharacterSet: CustomStringConvertible, ExpressibleByStringLiteral, RawRepresentable {
    public static var ascii: Self { "US-ASCII" }  // Default character encoding

    public let value: String

    init(_ value: String = "") {
        self = Self(rawValue: value) ?? .ascii
    }

    // MARK: CustomStringConvertible
    public var description: String { value }

    // MARK: ExpressibleByStringLiteral
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }

    // MARK: RawRepresentable
    public var rawValue: String { value }

    public init?(rawValue: String) {
        guard let data: Data = rawValue.data(using: .ascii),
            let value: String = String(data: data, encoding: .ascii),
            !value.isEmpty
        else {
            return nil
        }
        self.value = value
    }
}

extension CharacterSet {
    public static var utf8: Self { "UTF-8" }
}
