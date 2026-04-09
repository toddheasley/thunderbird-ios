/// ``IMAPClient`` connects to `Server`.
public struct Server: CustomStringConvertible, Equatable, Sendable {
    public let connectionSecurity: ConnectionSecurity
    public let hostname: String
    public let username: String?
    public let password: String?
    public let port: Int

    /// `Server` can be configured with or without basic auth credentials.
    ///
    /// User name and password can be provided at `login`, or another mechanism can be used to `authenticate`.
    public init(
        _ connectionSecurity: ConnectionSecurity = .tls,
        hostname: String,
        username: String? = nil,
        password: String? = nil,
        port: Int = 993
    ) {
        self.connectionSecurity = connectionSecurity
        self.hostname = hostname
        self.username = username
        self.password = password
        self.port = port
    }

    // MARK: CustomStringConvertible
    public var description: String { "\(hostname):\(port)" }
}
