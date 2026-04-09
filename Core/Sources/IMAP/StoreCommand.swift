import NIOCore
import NIOIMAP

// Set message flags and Gmail labels by mailbox sequence number
struct StoreCommand: IMAPCommand {
    let identifiers: MessageIdentifierSetNonEmpty<SequenceNumber>
    let data: StoreData

    init(_ identifiers: MessageIdentifierSetNonEmpty<SequenceNumber>, data: StoreData) {
        self.identifiers = identifiers
        self.data = data
    }

    // MARK: IMAPCommand
    typealias Result = Void
    typealias Handler = VoidResultHandler

    var name: String { "store" }

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .store(.set(identifiers), [], data))
    }
}
