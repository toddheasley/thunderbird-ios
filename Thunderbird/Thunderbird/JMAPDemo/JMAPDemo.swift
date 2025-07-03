@testable import Account
@testable import JMAP
import SwiftUI

@MainActor
@Observable final class JMAPDemo: Sendable {
    private(set) var mailboxes: [Mailbox] = []
    private(set) var session: Session? = nil
    private(set) var isRefreshing: Bool = false
    var error: Error? = nil

    var token: String = "" {
        didSet {
            URLCredentialStorage.shared.set(token, for: .user, space: .account)
            refresh()
        }
    }

    init() {
        token = URLCredentialStorage.shared.password(for: .user, space: .account) ?? ""
        refresh()
    }

    func refresh() {
        session = nil
        error = nil
        guard !token.isEmpty else { return }
        isRefreshing = true
        Task {
            do {
                session = try await URLSession.shared.session(token)
                guard let url: URL = session?.apiURL,
                    let id: String = session?.accounts.first?.key
                else {
                    throw URLError(.cannotConnectToHost)
                }
                mailboxes = try await URLSession.shared.mailboxes(token, url: url, account: id)
            } catch {
                self.error = error
            }
            isRefreshing = false
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
    func threads(_ token: String, url: URL, ids: [String], account id: String) async throws -> [Email] {
        guard
            let response: MethodGetResponse = try await jmapAPI(
                [
                    Thread.GetMethod(id, ids: ids)
                ], url: url, token: token
            ).first as? MethodGetResponse
        else {
            throw URLError(.cannotDecodeContentData)
        }
        let threads: [JMAP.Thread] = try response.decode([JMAP.Thread].self)
        guard let ids: [String] = threads.first?.emailIDs,
            !ids.isEmpty
        else {
            throw URLError(.cannotDecodeContentData)
        }
        return try await emails(token, url: url, ids: ids, account: id)
    }

    func emails(_ token: String, url: URL, in mailboxID: String, account id: String) async throws -> [Email] {
        guard
            let response: MethodQueryResponse = try await jmapAPI(
                [
                    Email.QueryMethod(id, filter: .inMailbox(mailboxID))
                ], url: url, token: token
            ).first as? MethodQueryResponse
        else {
            throw URLError(.cannotDecodeContentData)
        }
        return try await emails(token, url: url, ids: response.ids, account: id)
    }

    func emails(_ token: String, url: URL, ids: [String], account id: String) async throws -> [Email] {
        guard
            let response: MethodGetResponse = try await jmapAPI(
                [
                    Email.GetMethod(id, ids: ids)
                ], url: url, token: token
            ).first as? MethodGetResponse
        else {
            throw URLError(.cannotDecodeContentData)
        }
        return try response.decode([Email].self)
    }

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

extension URL {
    static let help: Self = Self(string: "https://www.fastmail.help/hc/en-us/articles/5254602856719-API-tokens")!
}

private extension String {
    static let user: Self = "fastmail.com"
}
