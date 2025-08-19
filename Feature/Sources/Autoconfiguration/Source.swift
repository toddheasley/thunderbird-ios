public enum Source: CaseIterable {
    case provider, wellKnown, ispDB  // Preferred order of precedence

    public static var `default`: Self { provider }
}
