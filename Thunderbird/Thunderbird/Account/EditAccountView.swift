import Account
import SwiftUI

struct EditAccountView: View {
    init(_ account: Account) {
        self.account = account
        self.incomingServer = account.incomingServer?.clone() ?? Server(.imap)
        self.outgoingServer = account.outgoingServer?.clone() ?? Server(.smtp)
    }

    @Environment(Accounts.self) private var accounts: Accounts
    @Environment(\.dismiss) var dismiss
    @State private var account: Account
    @State private var incomingServer: Server
    @State private var outgoingServer: Server

    // MARK: View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Incoming Server")
                    .font(.headline)
                EditServerView($incomingServer)
                Divider()
                Text("Outgoing Server")
                    .font(.headline)
                EditServerView($outgoingServer)

            }
            .padding()
        }
        .navigationTitle("Edit Account")
        .toolbar {
            Button(action: {
                account.servers = [
                    incomingServer,
                    outgoingServer
                ]
                accounts.set(account)
                dismiss()
            }) {
                Text("Save")
            }
        }
    }
}

#Preview("Edit Account View") {
    NavigationStack {
        EditAccountView(Account("example@thunderbird.net"))
    }
}

private extension Server {
    func clone() -> Self {
        var server: Self = Server(
            serverProtocol,
            connectionSecurity: connectionSecurity,
            authenticationType: authenticationType,
            username: username,
            hostname: hostname,
            port: port
        )
        switch authorization {
        case .basic(let user, let password): print("basic(user: \(user); password: \(password))")
        case .oauth(let user, let password): print("oauth(user: \(user); password: \(password))")
        case .none: print("none")
        }
        server.authorization = authorization
        return server
    }
}
