import Foundation
import NIOCore
import NIOIMAPCore

// Fetch messages by mailbox sequence number
struct FetchCommand: IMAPCommand {
    let identifiers: MessageIdentifierSetNonEmpty<SequenceNumber>
    let attributes: [FetchAttribute]

    init(_ identifiers: MessageIdentifierSetNonEmpty<SequenceNumber>, attributes: [FetchAttribute]) {
        self.identifiers = identifiers
        self.attributes = attributes
    }

    // MARK: IMAPCommand
    typealias Result = [MailboxInfo]
    typealias Handler = FetchHandler

    var name: String { "fetch" }

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .fetch(.set(identifiers), attributes, []))
    }
}

class FetchHandler: IMAPCommandHandler, @unchecked Sendable {

    // MARK: IMAPCommandHandler
    typealias InboundIn = Response
    typealias InboundOut = Response
    typealias Result = [MailboxInfo]

    var mailboxes: Result = []

    var sequenceNumber: SequenceNumber?
    var clientBug: String? = nil
    let promise: EventLoopPromise<Result>
    let tag: String

    required init(tag: String, promise: EventLoopPromise<Result>) {
        self.promise = promise
        self.tag = tag
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let response: Response = unwrapInboundIn(data)
        clientBug = response.clientBug
        switch response {
        case .tagged(let taggedResponse):
            switch taggedResponse.state {
            case .bad(let text), .no(let text):
                promise.fail(IMAPError.commandFailed(text.text))
            case .ok:
                promise.succeed(mailboxes)
            }
        case .fetch(let response):
            switch response {
            case .start(let sequenceNumber):
                self.sequenceNumber = sequenceNumber
            case .simpleAttribute(let attribute):
                switch attribute {
                case .emailID(let emailID):
                    print("*** emailID: \(String(emailID))")
                case .envelope(let envelope):
                    print("*** envelope: \(Envelope(envelope))")
                case .flags(let flags):
                    print("*** flags:")
                    for flag in flags {
                        print("***   \(flag)")
                    }
                case .internalDate(let serverMessageDate):
                    print("*** internalDate: \((try? Date(serverMessageDate: serverMessageDate))?.serverMessageDateFormat() ?? "nil")")
                case .threadID(let threadID):
                    print("*** threadID: \(String(threadID: threadID) ?? "nil")")
                case .uid(let uid):
                    print("*** UID: \(uid)")
                default:
                    break
                }
            case .finish:
                sequenceNumber = nil
            default:
                break
            }
        default:
            break
        }
        context.fireChannelRead(data)
    }
}

private extension String {
    init?(threadID: ThreadID?) {
        guard let threadID else {
            return nil
        }
        self = Self(threadID)
    }
}
