public enum Source: CaseIterable, CustomStringConvertible {
    case ispDB, provider, wellKnown

    public static var `default`: Self { ispDB }

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .ispDB: "ISPDB"
        case .provider: "provider"
        case .wellKnown: "provider (alternate)"
        }
    }
}
