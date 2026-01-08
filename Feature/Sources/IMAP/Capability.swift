import NIOIMAP
import NIOCore

struct CapabilityCommand: IMAPCommand {

    // MARK: IMAPCommand
    typealias Result = [Capability]
    typealias Handler = CapabilityHandler

    let description: String = "Capability command"

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .capability)
    }
}

class CapabilityHandler: IMAPCommandHandler, @unchecked Sendable {

    // MARK: IMAPCommandHandler
    typealias InboundIn = Response
    typealias InboundOut = Response
    typealias Result = [Capability]

    var capabilities: Result = []
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
                promise.fail(IMAPError.underlying("\(text)"))
            case .ok:
                promise.succeed(capabilities)
            }
            context.pipeline.removeHandler(self, promise: nil)
        case .untagged(let payload):
            switch payload {
            case .capabilityData(let capabilities):
                self.capabilities = capabilities
            default:
                break
            }
        default:
            break
        }
        context.fireChannelRead(data)
    }
}
