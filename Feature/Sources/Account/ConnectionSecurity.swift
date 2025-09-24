public enum ConnectionSecurity: String, Codable, CaseIterable, CustomStringConvertible, Identifiable {
    case startTLS = "STARTTLS"
    case tls = "SSL/TLS"
    case none

    // MARK: CustomStringConvertible
    public var description: String { rawValue }

    // MARK: Identifiable
    public var id: String { rawValue }
}
