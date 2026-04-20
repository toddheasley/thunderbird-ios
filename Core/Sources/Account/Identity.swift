public struct Identity: Codable, CustomStringConvertible, Hashable {
    public let emailAddress: String
    public let displayName: String?

    public init(_ emailAddress: String, displayName: String? = nil) {
        self.emailAddress = emailAddress
        self.displayName = displayName
    }

    // MARK: CustomStringConvertible
    public var description: String {
        (displayName ?? "").isEmpty ? "\(emailAddress)" : "\(displayName!) <\(emailAddress)>"
    }
}
