@testable import Account
@testable import JMAP
import SwiftUI

struct JMAPView: View {
    @State private var session: Session?
    @State private var mailboxes: [Mailbox] = []
    @State private var token: String = ""
    @State private var error: Error?

    private let user: String = "fastmail.com"

    // MARK: View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("JMAP Preview")
                    .font(.title)
                    .padding(.vertical)
                TextField(text: $token) {
                    Text("Fastmail API token")
                }
                .textFieldStyle(.roundedBorder)
                Link(destination: .help) {
                    Text("Generate a token")
                }
                if let error {
                    Divider()
                    Text("Error")
                        .font(.headline)
                    Text(error.localizedDescription)
                }
                if let session {
                    Divider()
                        .padding(.vertical)
                    Text("Session")
                        .font(.headline)
                    Text("\(session.username)")
                    if !mailboxes.isEmpty {
                        Text("Mailboxes")
                            .font(.headline)
                            .padding(.top)
                        ForEach(mailboxes) { mailbox in
                            MailboxView(mailbox)
                        }
                    }
                }
            }
            .padding()
        }
        .onChange(of: token) {
            error = nil
            mailboxes = []
            session = nil
            URLCredentialStorage.shared.set(token, for: user, space: .account)
            guard !token.isEmpty else { return }
            Task {
                do {
                    session = try await URLSession.shared.session(token)
                    let id: String = "\(session?.accounts.first?.key ?? "")"
                    guard let url: URL = session?.apiURL else {
                        throw URLError(.cannotFindHost)
                    }
                    mailboxes = try await URLSession.shared.mailboxes(token, url: url, account: id)
                } catch {
                    self.error = error
                }
            }
        }
        .onAppear {
            error = nil
            token = URLCredentialStorage.shared.password(for: user, space: .account) ?? ""
        }
    }
}

#Preview("JMAP View") {
    JMAPView()
}

struct MailboxView: View {
    let mailbox: Mailbox

    init(_ mailbox: Mailbox) {
        self.mailbox = mailbox
    }

    // MARK: View
    var body: some View {
        HStack {
            Image(systemName: "folder")
            Text(mailbox.name)
        }
    }
}

extension URL {
    static let help: Self = Self(string: "https://www.fastmail.help/hc/en-us/articles/5254602856719-API-tokens")!
}

extension URLSession {
    func mailboxes(_ token: String, url: URL, account id: String) async throws -> [Mailbox] {
        guard
            let response: MethodGetResponse = try await jmapAPI(
                [
                    Mailbox.GetMethod(id)
                ], url: url, token: token
            ).first as? MethodGetResponse
        else {
            throw URLError(.cannotDecodeContentData)
        }
        return try response.decode([Mailbox].self)
    }

    func session(_ token: String) async throws -> Session {
        try await jmapSession("api.fastmail.com", port: 443, token: token)
    }
}
