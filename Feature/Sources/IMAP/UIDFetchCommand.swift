import NIOCore
import NIOIMAP

// Fetch messages by UID
struct UIDFetchCommand: IMAPCommand {
    let identifiers: UIDSetNonEmpty
    let attributes: [FetchAttribute]

    init(_ identifiers: UIDSetNonEmpty, attributes: [FetchAttribute]) {
        self.identifiers = identifiers
        self.attributes = attributes
    }

    // MARK: IMAPCommand
    typealias Result = [SequenceNumber: Message]
    typealias Handler = FetchHandler

    var name: String { "fetch" }

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .uidFetch(.set(identifiers), attributes, []))
    }
}
