import Core
import SwiftUI

struct AccountTestView: View {
    init(_ account: Account) {
        self.account = account
    }

    private let account: Account

    // MARK: View
    var body: some View {
        ContentUnavailableView {
            Label("\(account.name)", systemImage: "stethoscope")
        }
    }
}

#Preview {
    @Previewable @State var account: Account = Account(name: "")

    AccountTestView(account)
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
