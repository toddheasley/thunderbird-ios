import NIOCore
import NIOIMAP

// Move messages by UID to a destination mailbox
struct UIDMoveCommand: IMAPCommand {
    let identifiers: UIDSetNonEmpty
    let mailboxName: MailboxName

    init(_ identifiers: UIDSetNonEmpty, to mailboxName: MailboxName) {
        self.identifiers = identifiers
        self.mailboxName = mailboxName
    }

    // MARK: IMAPCommand
    typealias Result = Void
    typealias Handler = VoidResultHandler

    var name: String { "move" }

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .uidMove(.set(identifiers), mailboxName))
    }
}
