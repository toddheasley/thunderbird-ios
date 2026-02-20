import Foundation
import NIOCore
import NIOIMAP

// Poll server for events during idle
struct NoopCommand: IMAPCommand {

    // MARK: IMAPCommand
    typealias Result = [IdleEvent]
    typealias Handler = NoopHandler

    var name: String { "noop" }

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .noop)
    }
}

class NoopHandler: IMAPCommandHandler, @unchecked Sendable {
    private(set) var events: [IdleEvent] = []

    private var components: [Message.Component] = []
    private var sequenceNumber: SequenceNumber?
    private var status: MailboxStatus = MailboxStatus()

    // MARK: IMAPCommandHandler
    typealias InboundIn = Response
    typealias InboundOut = Response
    typealias Result = [IdleEvent]

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
                if !status.isEmpty {
                    events.append(.status(status))
                }
                promise.succeed(events)
            }
        case .untagged(let payload):
            switch payload {
            case .conditionalState(let status):
                switch status {
                case .bye(let text):
                    events.append(.bye(text.text))
                default:
                    break
                }
            case .mailboxData(let data):
                switch data {
                case .exists(let count):
                    status.messageCount = count
                case .recent(let count):
                    status.recentCount = count
                default:
                    break
                }
            default:
                break
            }
        case .fetch(let response):
            switch response {
            case .start(let sequenceNumber):
                self.sequenceNumber = sequenceNumber
                components = []
            case .simpleAttribute(let attribute):
                guard let component: Message.Component = Message.Component(attribute) else { break }
                components.append(component)
            case .finish:
                guard let sequenceNumber, !events.isEmpty else { break }
                events.append(.fetch(sequenceNumber, components))
                self.sequenceNumber = nil
                components = []
            default:
                break
            }
        case .fatal(let text):
            events.append(.bye(text.text))
        default:
            break
        }
        context.fireChannelRead(data)
    }
}

private extension MailboxStatus {
    var isEmpty: Bool { messageCount == nil && recentCount == nil }
}
