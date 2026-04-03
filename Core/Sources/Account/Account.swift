@_exported import Autoconfiguration
@_exported import EmailAddress
import Foundation

public struct Account: Codable, Equatable, Hashable, Identifiable {
    public var name: String
    public var deletePolicy: DeletePolicy
    public var identities: [EmailAddress]
    public var servers: [Server]

    public var incomingServer: Server? { server(.jmap) ?? server(.imap) ?? nil }
    public var outgoingServer: Server? { server(.jmap) ?? server(.smtp) ?? nil }

    /// Configure an `Account` using ``Autoconfiguration.EmailProvider``.
    public init(_ emailAddress: String, provider: EmailProvider? = nil) {
        self.init(EmailAddress(emailAddress), provider: provider)
    }

    /// Configure an `Account` using ``Autoconfiguration.EmailProvider``.
    public init(_ emailAddress: EmailAddress, provider: EmailProvider? = nil) {
        self.init(
            name: emailAddress.value,
            identities: [
                emailAddress
            ],
            servers: (provider?.servers ?? []).compactMap { Server($0) },
        )
    }

    /// Configure an `Account` using memberwise initializer.
    public init(
        name: String,
        deletePolicy: DeletePolicy = .never,
        identities: [EmailAddress] = [],
        servers: [Server] = [],
        id: UUID = UUID()
    ) {
        self.name = name
        self.deletePolicy = deletePolicy
        self.identities = identities
        self.servers = servers
        self.id = id
    }

    func server(_ serverProtocol: ServerProtocol) -> Server? {
        servers.filter { $0.serverProtocol == serverProtocol }.first
    }

    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id  // Account equality based on UUID exclusively
    }

    // MARK: Identifiable
    public let id: UUID
}
