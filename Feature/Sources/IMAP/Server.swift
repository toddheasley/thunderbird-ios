/// ``IMAPClient`` connects to `Server`.
public struct Server: Equatable, Sendable {
    public let connectionSecurity: ConnectionSecurity
    public let hostname: String
    public let username: String
    public let password: String
    public let port: Int

    public init(
        _ connectionSecurity: ConnectionSecurity = .tls,
        hostname: String,
        username: String,
        password: String,
        port: Int = 993
    ) {
        self.connectionSecurity = connectionSecurity
        self.hostname = hostname
        self.username = username
        self.password = password
        self.port = port
    }
}
