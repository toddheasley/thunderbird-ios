import Core
import Foundation

extension AccountManager {
    func deleteAccounts(at indexSet: IndexSet) {
        let accounts: [Account] = indexSet.compactMap { allAccounts[$0] }
        for account in accounts {
            delete(account)
        }
    }

}

extension Account {
    func test() async throws {
        switch emailProtocol {
        case .imap:
            guard let server: Server = incomingServer, server.serverProtocol == .imap else {
                throw IMAPError.serverProtocolMismatch
            }
            guard server.authenticationType != .oAuth2 else {
                throw IMAPError.oAuth2NotSupported
            }
            let client: IMAPClient = IMAPClient(try IMAP.Server(server))
            try await client.connect()
            guard client.isConnected else {
                throw IMAPError.notConnected
            }
            try client.disconnect()
        case .jmap:
            throw JMAPError.method(.accountNotSupportedByMethod)
        }
    }
}
