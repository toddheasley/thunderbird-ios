import Account
import Autoconfiguration

extension Account {
    // Configure an `Account` using `Autoconfiguration.EmailProvider`
    init(_ emailAddress: EmailAddress, provider: EmailProvider? = nil) {
        self.init(name: emailAddress, servers: (provider?.servers ?? []).compactMap { Server($0) })
    }
}

private extension Server {
    init?(_ server: EmailProvider.Server) {
        guard let serverProtocol: ServerProtocol = ServerProtocol(server.serverType) else {
            return nil  // App only supports IMAP and SMTP
        }
        self.init(
            serverProtocol,
            connectionSecurity: ConnectionSecurity(server.socketType),
            authenticationType: AuthenticationType(server.authentication),
            username: server.username,
            hostname: server.hostname,
            port: server.port
        )
    }
}

private extension ServerProtocol {
    init?(_ serverType: EmailProvider.Server.ServerType) {
        switch serverType {
        case .imap:
            self = .imap
        case .smtp:
            self = .smtp
        default:
            return nil
        }
    }
}

private extension ConnectionSecurity {
    init(_ socketType: EmailProvider.Server.SocketType) {
        switch socketType {
        case .startTLS: self = .startTLS
        case .ssl: self = .tls
        }
    }
}

private extension AuthenticationType {
    init(_ authentication: [EmailProvider.Server.Authentication]) {
        if authentication.contains(.oAuth2) {
            self = .oAuth2  // Prefer OAuth2
        } else if authentication.contains(.passwordCleartext) {
            self = .password
        } else {
            self = .none
        }
    }
}
