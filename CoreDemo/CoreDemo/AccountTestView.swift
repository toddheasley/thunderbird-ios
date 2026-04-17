import Core
import SwiftUI

struct AccountTestView: View {
    let account: Account

    init(_ account: Account) {
        self.account = account
    }

    @State private var results: [TestResult] = []
    @State private var isTesting: Bool = false

    // MARK: View
    var body: some View {
        VStack {
            ContentUnavailableView("\(account.name)", systemImage: "stethoscope")
            ForEach(results) { result in
                HStack {
                    Text(result.description)
                    Spacer()
                    Image(systemName: result.isFailure ? "xmark.circle.fill" : "checkmark.circle.fill")
                }
            }
            HStack {
                Text("Testing…")
                Spacer()
                ProgressView()
            }
            .opacity(isTesting ? 1.0 : 0.0)
        }
        .padding()
        .task {
            isTesting = true
            switch account.emailProtocol {
            case .imap:
                guard let incomingServer: Server = account.incomingServer else {
                    results.append(.imapConnect(IMAPError.serverProtocolMismatch))
                    break
                }
                do {
                    let server: IMAP.Server = try IMAP.Server(incomingServer)
                    let client: IMAPClient = IMAPClient(server)
                    try await client.connect()
                    results.append(.imapConnect())
                    try await client.login()
                    results.append(.imapAuthenticate())
                    for capability in client.capabilities {
                        results.append(.imapCapability(capability))
                        try await Task.sleep(for: .milliseconds(100))  // Just for drama
                    }
                    try await client.logout()
                } catch {
                    results.append(.imapConnect(error))
                }
            case .jmap:
                results.append(.jmapSession(JMAPError.method(.accountNotSupportedByMethod)))
            }
            isTesting = false
        }
    }
}

#Preview {
    @Previewable @State var account: Account = Account(name: "")

    AccountTestView(account)
}

private enum TestResult: CustomStringConvertible, Identifiable, Sendable {
    case imapConnect(Error? = nil)
    case imapAuthenticate(Error? = nil)
    case imapCapability(IMAP.Capability, Error? = nil)
    case jmapSession(Error? = nil)
    case jmapCapability(JMAP.Capability, Error? = nil)
    case smtpSend(Error? = nil)

    var error: Error? {
        switch self {
        case .imapConnect(let error),
            .imapAuthenticate(let error),
            .imapCapability(_, let error),
            .jmapSession(let error),
            .jmapCapability(_, let error),
            .smtpSend(let error):
            error
        }
    }

    var isFailure: Bool { error != nil }

    // MARK: CustomStringConvertible
    var description: String {
        switch self {
        case .imapConnect: "IMAP CONNECT"
        case .imapAuthenticate: "IMAP AUTHENTICATE"
        case .imapCapability(let capability, _): "IMAP CAPABILITY: \(capability)"
        case .jmapSession: "JMAP SESSION"
        case .jmapCapability(let capability, _): "JMAP CAPABILITY: \(capability)"
        case .smtpSend: "SMTP SEND"
        }
    }

    // MARK: Identifiable
    var id: String { description }
}
