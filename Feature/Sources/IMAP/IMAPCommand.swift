import Foundation
import NIOIMAP
import NIOCore

protocol IMAPCommand: CustomStringConvertible, Equatable where Result: Sendable {
    associatedtype Result
    associatedtype Handler: IMAPCommandHandler where Handler.Result == Result
    var timeout: Int64 { get }  // Seconds
    func tagged(_ tag: String) -> TaggedCommand
}

extension IMAPCommand {

    // MARK: IMAPCommand
    var timeout: Int64 { 10 }  // Practical default

    // MARK: CustomStringConvertible
    var description: String { fatalError("description has not been implemented") }
}

protocol IMAPCommandHandler: ChannelInboundHandler, RemovableChannelHandler, Sendable where Result: Sendable {
    associatedtype Result
    init(tag: String, promise: EventLoopPromise<Result>)
    var promise: EventLoopPromise<Result> { get }
    var tag: String { get }
    var clientBug: String? { get set }
}

extension IMAPCommandHandler where InboundIn == Response {

}

// Default implementation for void-result commands
extension IMAPCommandHandler where InboundIn == Response, Result == Void {

    // MARK: IMAPCommandHandler
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let response: Response = unwrapInboundIn(data)
        clientBug = response.clientBug
        switch response {
        case .tagged(let taggedResponse):
            switch taggedResponse.state {
            case .ok:
                promise.succeed(())
            case .bad(let text), .no(let text):
                promise.fail(IMAPError.underlying(text.text))
            }
        default:
            promise.fail(IMAPError.underlying("Unexpected response"))
        }
        context.pipeline.removeHandler(self, promise: nil)
        context.fireChannelRead(data)
    }
}

extension IMAPCommandHandler {

    // MARK: IMAPCommandHandler
    func errorCaught(context: ChannelHandlerContext, error: any Error) {
        promise.fail(error)
        context.pipeline.removeHandler(self, promise: nil)
        context.fireErrorCaught(error)
    }
}

extension Response {
    var clientBug: String? {
        switch self {
        case .tagged(let response):
            guard response.state.responseText.code == .clientBug else { fallthrough }
            return response.state.responseText.text
        default:
            return nil
        }
    }
}

extension TaggedResponse.State {
    var responseText: ResponseText {
        switch self {
        case .bad(let responseText), .no(let responseText), .ok(let responseText): responseText
        }
    }
}
