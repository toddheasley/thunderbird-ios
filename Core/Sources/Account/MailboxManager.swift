import Foundation

@Observable
public final class MailboxManager {
    public let account: Account
    public private(set) var mailboxes: [Mailbox] = []
    public var error: AccountError?

    public init(account: Account) {
        self.account = account
    }

    public func mailbox(for id: String) -> Mailbox? {
        mailboxes.filter({ $0.id == id }).first
    }

    public func refreshMailboxes() async {
        do {
            switch account.emailProtocol {
            case .imap:
                let client: IMAPClient = try await account.imapClient
                let mailboxes: [(IMAP.Mailbox, IMAP.Mailbox.Status?)] = try await client.list()
                self.mailboxes = mailboxes.map { Mailbox($0) }
            case .jmap:
                let client: JMAPClient = try await account.jmapClient
                let mailboxes: [JMAP.Mailbox] = try await client.mailboxes()
                self.mailboxes = mailboxes.map { Mailbox($0) }
            }
        } catch {
            self.error = AccountError(error)
        }
    }
}
