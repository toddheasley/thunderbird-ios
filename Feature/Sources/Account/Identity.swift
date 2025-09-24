public struct Identity: Codable, CustomStringConvertible, Hashable {
    public let emailAddress: EmailAddress
    public let displayName: String?

    public init(_ emailAddress: EmailAddress, displayName: String? = nil) {
        self.emailAddress = emailAddress
        self.displayName = displayName
    }

    // MARK: CustomStringConvertible
    public var description: String {
        (displayName ?? "").isEmpty ? "\(emailAddress)" : "\(displayName!) <\(emailAddress)>"
    }
}
