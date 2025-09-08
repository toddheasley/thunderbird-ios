/// Autoconfig locations to query, in order of trust: email provider subdomain or well-known, then ISPDB
public enum Source: CaseIterable, CustomStringConvertible {
    case provider, wellKnown, ispDB  // Order of trust

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .provider: "provider"
        case .wellKnown: "provider (alternate)"
        case .ispDB: "ISPDB"
        }
    }
}
