import NIOCore
import NIOIMAP

// Copy messages by UID to a destination mailbox
struct UIDCopyCommand: IMAPCommand {
    let identifiers: UIDSetNonEmpty
    let mailboxName: MailboxName

    init(_ identifiers: UIDSetNonEmpty, to mailboxName: MailboxName) {
        self.identifiers = identifiers
        self.mailboxName = mailboxName
    }

    // MARK: IMAPCommand
    typealias Result = Void
    typealias Handler = VoidResultHandler

    var name: String { "copy" }

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .uidCopy(.set(identifiers), mailboxName))
    }
}
