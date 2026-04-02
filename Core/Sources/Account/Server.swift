import Foundation
import IMAP
import JMAP
import MIME
import SMTP

/// All supported server types enumerated.
public enum ServerProtocol: String, Codable, CaseIterable, CustomStringConvertible, Identifiable {
    case imap = "IMAP"
    case jmap = "JMAP"
    case smtp = "SMTP"

    var defaultPort: Int {
        switch self {
        case .imap: IMAP.Server(hostname: "").port
        case .jmap: JMAP.Server(authorization: nil, host: "").port
        case .smtp: SMTP.Server(hostname: "", username: "", password: "").port
        }
    }

    // MARK: CustomStringConvertible
    public var description: String { rawValue }

    // MARK: Identifiable
    public var id: String { rawValue }
}

/// General purpose server model for any supported `ServerProtocol`. Stores authorization credentials locally in the [Apple keychain.](https://developer.apple.com/documentation/security/storing-keys-in-the-keychain)
public struct Server: Codable, Equatable, Hashable, Identifiable {
    public var serverProtocol: ServerProtocol
    public var connectionSecurity: ConnectionSecurity
    public var authenticationType: AuthenticationType
    public var username: String
    public var hostname: String
    public var port: Int

    /// Store server credentials locally in the [Apple keychain.](https://developer.apple.com/documentation/security/storing-keys-in-the-keychain)
    public var authorization: Authorization {
        set {  // Swap in keychain-specific user name
            let authorization: Authorization = Authorization(user: user, password: newValue.password)
            URLCredentialStorage.shared.set(authorization: authorization, persistence: .permanent)
        }
        get {
            guard let authorization: Authorization = URLCredentialStorage.shared.authorization(for: user) else {
                return .none
            }
            return Authorization(user: username, password: authorization.password)  // Swap out keychain-specific user name
        }
    }

    public init(
        _ serverProtocol: ServerProtocol,
        connectionSecurity: ConnectionSecurity = .none,
        authenticationType: AuthenticationType = .none,
        username: String = "",
        hostname: String = "",
        port: Int? = nil,
        id: UUID = UUID()
    ) {
        self.serverProtocol = serverProtocol
        self.connectionSecurity = connectionSecurity
        self.authenticationType = authenticationType
        self.username = username
        self.hostname = hostname
        self.port = port ?? serverProtocol.defaultPort
        self.id = id
    }

    var user: String {  // Append unique suffix for keychain: "user@example.com IMAP:E621E1F8"
        "\(username) \(serverProtocol):\(id.uuidString(1))"
    }

    // MARK: Identifiable
    public let id: UUID
}
