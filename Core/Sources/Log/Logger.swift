import OSLog

extension Logger {
    public static func shared(_ category: String) -> Self {
        Self(subsystem: .subsystem, category: category)
    }
}

extension String {
    static let subsystem: Self = "net.thunderbird.ios"
}
