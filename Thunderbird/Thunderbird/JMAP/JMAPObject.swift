import Account
import JMAP
import SwiftUI

@MainActor
@Observable final class JMAPObject: Sendable {
    private(set) var session: Session? = nil
    var error: Error? = nil

    var token: String = "" {
        didSet {
            // URLCredentialStorage.shared.set(authorization: .oauth(user: .user, token: token))
            Task {
                await session()
            }
        }
    }

    init() {
        token = ""  // URLCredentialStorage.shared.authorization(for: .user)?.password ?? ""
        Task {
            await session()
        }
    }

    func thread(for email: Email) async -> [Email] {
        do {
            guard let url: URL = session?.apiURL,
                let id: String = session?.accounts.first?.key
            else {
                throw URLError(.cannotConnectToHost)
            }
            return try await URLSession.shared.thread(token, url: url, for: email, account: id)
        } catch {
            self.error = error
            return []
        }
    }

    func emails(in mailbox: Mailbox) async -> [Email] {
        do {
            guard let url: URL = session?.apiURL,
                let id: String = session?.accounts.first?.key
            else {
                throw URLError(.cannotConnectToHost)
            }
            return try await URLSession.shared.emails(token, url: url, in: mailbox, account: id)
        } catch {
            self.error = error
            return []
        }
    }

    func mailboxes() async -> [Mailbox] {
        do {
            guard let url: URL = session?.apiURL,
                let id: String = session?.accounts.first?.key
            else {
                throw URLError(.cannotConnectToHost)
            }
            return try await URLSession.shared.mailboxes(token, url: url, account: id)
        } catch {
            self.error = error
            return []
        }
    }

    func session() async {
        session = nil
        error = nil
        guard !token.isEmpty else { return }
        do {
            session = try await URLSession.shared.session(token)
        } catch {
            self.error = error
        }
    }
}

extension Mailbox {
    var systemName: String {
        switch role {
        case .inbox: "tray.full"
        case .drafts: "envelope.open"
        case .sent: "paperplane"
        case .archive: "archivebox"
        case .junk: "xmark.bin"
        case .trash: "trash"
        default: "folder"
        }
    }
}

extension Filter {
    static func inMailbox(_ id: String) -> Self {
        Self([
            Email.Condition.inMailbox(id)
        ])
    }
}

extension URLSession {
    func thread(_ token: String, url: URL, for email: Email, account id: String) async throws -> [Email] {
        throw URLError(.resourceUnavailable)
    }

    func emails(_ token: String, url: URL, in mailbox: Mailbox, account id: String) async throws -> [Email] {
        throw URLError(.resourceUnavailable)
    }

    func emails(_ token: String, url: URL, ids: [String], account id: String) async throws -> [Email] {
        throw URLError(.resourceUnavailable)
    }

    func mailboxes(_ token: String, url: URL, account id: String) async throws -> [Mailbox] {
        throw URLError(.resourceUnavailable)
    }

    func session(_ token: String) async throws -> Session {
        try await jmapSession("api.fastmail.com", port: 443, authorization: "Bearer \(token)")
    }
}

extension URL {
    static let help: Self = Self(string: "https://www.fastmail.help/hc/en-us/articles/5254602856719-API-tokens")!
}

private extension String {
    static let user: Self = "fastmail.com"
}
