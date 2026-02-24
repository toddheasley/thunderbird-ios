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
    typealias Result = [SequenceNumber: Message]
    typealias Handler = FetchHandler

    var name: String { "fetch" }

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .fetch(.set(identifiers), attributes, []))
    }
}

class FetchHandler: IMAPCommandHandler, @unchecked Sendable {
    var messages: Result = [:]
    var isStreaming: Bool { streaming != nil }

    private var streaming: (kind: StreamingKind, data: Data, byteCount: Int)?
    private var components: [Message.Component] = []
    private var sequenceNumber: SequenceNumber?

    // MARK: IMAPCommandHandler
    typealias InboundIn = Response
    typealias InboundOut = Response
    typealias Result = [SequenceNumber: Message]

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
                promise.succeed(messages)
            }
        case .fetch(let response):
            switch response {
            case .start(let sequenceNumber):
                self.sequenceNumber = sequenceNumber
            case .simpleAttribute(let attribute):
                switch attribute {
                case .body(let structure, let hasExtensionData):
                    components.append(.bodyStructure(structure, hasExtensionData))
                case .emailID(let emailID):
                    components.append(.emailID(String(emailID)))
                case .envelope(let envelope):
                    components.append(.envelope(Envelope(envelope)))
                case .flags(let flags):
                    components.append(.flags(Set(flags)))
                case .gmailLabels(let labels):
                    components.append(.gmailLabels(labels))
                case .gmailMessageID(let id):
                    components.append(.gmailMessageID(id))
                case .gmailThreadID(let id):
                    components.append(.gmailThreadID(id))
                case .internalDate(let serverMessageDate):
                    if let date: Date = try? Date(serverMessageDate: serverMessageDate) {
                        components.append(.internalDate(date))
                    }
                case .threadID(let threadID):
                    if let threadID: String = String(threadID: threadID) {
                        components.append(.threadID(threadID))
                    }
                case .uid(let uid):
                    components.append(.uid(uid))
                default:
                    break
                }
            case .streamingBegin(let kind, let byteCount):
                streaming = (kind, Data(), byteCount)
            case .streamingBytes(let bytes):
                streaming?.data.append(Data(bytes.readableBytesView))
            case .streamingEnd:
                if let streaming {
                    switch streaming.kind {
                    case .body(let section, _):
                        guard streaming.data.count == streaming.byteCount else { break }
                        components.append(.bodyPart(section, streaming.data))
                    default:
                        break
                    }
                }
                streaming = nil
            case .finish:
                messages[sequenceNumber!] = Message(components: components)
                sequenceNumber = nil
                components = []
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
