public struct EmailAddress: Codable, CustomStringConvertible, ExpressibleByStringLiteral, RawRepresentable {

    // MARK: CustomStringConvertible
    public var description: String { rawValue }

    // MARK: ExpressibleByStringLiteral
    public init(stringLiteral value: String) {
        self.rawValue = value
    }

    // MARK: RawRepresentable
    public let rawValue: String

    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}
