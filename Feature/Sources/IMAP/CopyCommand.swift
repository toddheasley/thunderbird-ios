import NIOCore
import NIOIMAP

// Copy messages by mailbox sequence number to a destination mailbox
struct CopyCommand: IMAPCommand {
    let identifiers: MessageIdentifierSetNonEmpty<SequenceNumber>
    let mailboxName: MailboxName

    init(_ identifiers: MessageIdentifierSetNonEmpty<SequenceNumber>, to mailboxName: MailboxName) {
        self.identifiers = identifiers
        self.mailboxName = mailboxName
    }

    // MARK: IMAPCommand
    typealias Result = Void
    typealias Handler = VoidResultHandler

    var name: String { "copy" }

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .copy(.set(identifiers), mailboxName))
    }
}
