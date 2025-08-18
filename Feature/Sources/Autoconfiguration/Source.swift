public enum Source: CaseIterable {
    case provider, wellKnown, ispDB  // Preferred order

    public static var `default`: Self { provider }
}
