public enum AuthenticationType: String, Codable, CaseIterable, CustomStringConvertible, Identifiable {
    case password
    case oAuth2 = "OAuth2"
    case none

    // MARK: CustomStringConvertible
    public var description: String { rawValue }

    // MARK: Identifiable
    public var id: String { rawValue }
}
