import NIOCore
import NIOIMAP

// Move messages by mailbox sequence number to a destination mailbox
struct MoveCommand: IMAPCommand {
    let identifiers: MessageIdentifierSetNonEmpty<SequenceNumber>
    let mailboxName: MailboxName

    init(_ identifiers: MessageIdentifierSetNonEmpty<SequenceNumber>, to mailboxName: MailboxName) {
        self.identifiers = identifiers
        self.mailboxName = mailboxName
    }

    // MARK: IMAPCommand
    typealias Result = Void
    typealias Handler = VoidResultHandler

    var name: String { "move" }

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .move(.set(identifiers), mailboxName))
    }
}
