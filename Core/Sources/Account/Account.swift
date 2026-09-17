// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

@_exported import Autoconfiguration
@_exported import EmailAddress
@_exported import IMAP
@_exported import JMAP
@_exported import MIME
@_exported import SMTP
import Foundation

public struct Account: Codable, Equatable, Hashable, Identifiable, Sendable {
    public enum EmailProtocol: String, CaseIterable, CustomStringConvertible, Identifiable {
        case imap = "IMAP/SMTP"
        case jmap = "JMAP"

        // MARK: CustomStringConvertible
        public var description: String { rawValue }

        // MARK: Identifiable
        public var id: String { rawValue }
    }

    public var name: String
    public var deletePolicy: DeletePolicy
    public var identities: [EmailAddress]
    public var servers: [Server]
    public var avatarColor: String
    public var autoconfigured: Source?

    public var incomingServer: Server? { server(.jmap) ?? server(.imap) ?? nil }
    public var outgoingServer: Server? { server(.jmap) ?? server(.smtp) ?? nil }
    public var emailAddress: EmailAddress? { identities.first }

    public var authConfig: OAuth2.Configuration? {
        get async throws {
            fatalError()
        }
    }

    /// Store account credentials locally in the [Apple keychain.](https://developer.apple.com/documentation/security/storing-keys-in-the-keychain)
    public var authorization: Authorization {
        set {
            guard let user: String = emailAddress?.value, !user.isEmpty else { return }
            URLCredentialStorage.shared.deleteAuthorization(for: user)
            guard !newValue.password.isEmpty else { return }
            URLCredentialStorage.shared.set(authorization: Authorization(user: user, password: newValue.password), persistence: .permanent)
        }
        get {
            guard let user: String = emailAddress?.value, !user.isEmpty,
                let authorization: Authorization = URLCredentialStorage.shared.authorization(for: user)
            else {
                return .none
            }
            return Authorization(user: user, password: authorization.password)
        }
    }

    public func deleteAuthorization() {
        guard let user: String = emailAddress?.value, !user.isEmpty else { return }
        URLCredentialStorage.shared.deleteAuthorization(for: user)
    }

    public var emailProtocol: EmailProtocol {
        servers.map { $0.serverProtocol }.contains(.jmap) ? .jmap : .imap
    }

    public func server(_ serverProtocol: ServerProtocol) -> Server? {
        servers.filter { $0.serverProtocol == serverProtocol }.first
    }

    public init(_ emailAddress: String) {
        self.init(EmailAddress(emailAddress))
    }

    public init(_ emailAddress: EmailAddress) {
        self.init(
            name: emailAddress.value,
            identities: [
                emailAddress
            ]
        )
    }

    /// Configure an `Account` using memberwise initializer.
    public init(
        name: String = "",
        deletePolicy: DeletePolicy = .never,
        identities: [EmailAddress] = [],
        servers: [Server] = [],
        id: UUID = UUID(),
        avatar: String = "user-blue",
    ) {
        self.name = name
        self.deletePolicy = deletePolicy
        self.identities = identities
        self.servers = servers
        self.id = id
        self.avatarColor = avatar
    }

    // MARK: Identifiable
    public let id: UUID
}

extension Account {
    /// Autoconfigure a new account from an email address `String`.
    public static func autoconfigured(_ emailAddress: String) async throws -> Self {
        try await Self(EmailAddress(emailAddress)).autoconfigured()
    }

    /// Autoconfigure a new account from an `EmailAddress`.
    public static func autoconfigured(_ emailAddress: EmailAddress) async throws -> Self {
        try await Self(emailAddress).autoconfigured()
    }

    /// Autoconfigure a new account using its ``EmailAddress``.
    public func autoconfigured() async throws -> Self {
        do {
            guard let emailAddress else {
                throw AccountError.autoconfigRequiresEmail
            }
            let autoconfig: (ClientConfig, Source) = try await URLSession.shared.autoconfig(emailAddress.value)
            var account: Self = Self(
                name: emailAddress.value,
                identities: [
                    emailAddress
                ],
                servers: (autoconfig.0.emailProvider?.servers ?? []).compactMap { Server($0) },
                id: id
            )
            // account.authConfig = try await OAuth2.configuration(emailAddress)
            account.autoconfigured = autoconfig.1
            return account
        } catch {
            throw AccountError.autoconfig(error)
        }
    }
}

extension Account {
    var imapClient: IMAPClient {
        get async throws {
            if let client: IMAPClient = Self.clients[id] as? IMAPClient {
                // IMAP Client already exists for account ID; reconnect and return
                if !client.isConnected {
                    try await client.connect()
                    try await client.login()
                }
                return client
            } else {
                // No client exists for account ID; make a new one, connect and return
                guard let incomingServer else {
                    throw IMAPError.serverProtocolMismatch
                }
                let client: IMAPClient = IMAPClient(try IMAP.Server(incomingServer, authorization: authorization))
                try await client.connect()
                try await client.login()
                Self.clients[id] = client  // Donate to shared pool
                return client
            }
        }
    }

    var jmapClient: JMAPClient {
        get async throws {
            if let client: JMAPClient = Self.clients[id] as? JMAPClient, client.session != nil {
                // JMAP Client already exists for account ID; return
                return client
            } else {
                // No client exists for account ID; start a new session and return
                guard let server: Server = servers.first else {
                    throw JMAPError.serverProtocolMismatch
                }
                let client: JMAPClient = try await .session(try JMAP.Server(server, authorization: authorization))
                guard client.session != nil else {
                    throw JMAPError.sessionNotFound
                }
                return client
            }
        }
    }

    // Share existing IMAP and JMAP clients associated with account
    nonisolated(unsafe) private static var clients: [UUID: Any] = [:]
}
