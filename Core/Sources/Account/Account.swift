import Foundation

public struct Account: Codable, Equatable, Hashable, Identifiable {
    public var name: String
    public var deletePolicy: DeletePolicy
    public var identities: [Identity]
    public var servers: [Server]

    public var incomingServer: Server? { server(.jmap) ?? server(.imap) ?? nil }
    public var outgoingServer: Server? { server(.jmap) ?? server(.smtp) ?? nil }

    public init(
        name: String,
        deletePolicy: DeletePolicy = .never,
        identities: [Identity] = [],
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
