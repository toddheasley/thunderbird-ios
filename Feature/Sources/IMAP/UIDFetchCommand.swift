import NIOCore
import NIOIMAP

// Fetch messages by UID
struct UIDFetchCommand: IMAPCommand {
    let identifiers: MessageIdentifierSetNonEmpty<UID>
    let attributes: [FetchAttribute]

    init(_ identifiers: MessageIdentifierSetNonEmpty<UID>, attributes: [FetchAttribute]) {
        self.identifiers = identifiers
        self.attributes = attributes
    }

    // MARK: IMAPCommand
    typealias Result = [Message.Component]
    typealias Handler = FetchHandler

    var name: String { "fetch" }

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .uidFetch(.set(identifiers), attributes, []))
    }
}
