public enum Source: CaseIterable, CustomStringConvertible {
    case provider, wellKnown, ispDB  // In order of trust

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .provider: "provider"
        case .wellKnown: "provider (alternate)"
        case .ispDB: "ISPDB"
        }
    }
}
