import Foundation

@Observable
public final class MailboxManager {
    public private(set) var mailboxes: [Mailbox] = []
    public var error: AccountError?
    public let account: Account

    public init(account: Account) {
        self.account = account
    }

    public func refreshMailboxes() async {
        do {
            mailboxes = try await list()
        } catch {
            self.error = AccountError(error)
        }
    }

    private func list() async throws -> [Mailbox] {
        switch account.emailProtocol {
        case .imap:
            let client: IMAPClient = try await account.imapClient
            let mailboxes: [IMAP.Mailbox] = try await client.list()
            return mailboxes.map { Mailbox($0) }
        case .jmap:
            let client: JMAPClient = try await account.jmapClient
            let mailboxes: [JMAP.Mailbox] = try await client.mailboxes()
            return mailboxes.map { Mailbox($0) }
        }
    }
}
