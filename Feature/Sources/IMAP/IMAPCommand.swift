import Foundation
import NIOIMAP
import NIOCore

protocol IMAPCommand: CustomStringConvertible where Result: Sendable {
    associatedtype Result
    associatedtype Handler: IMAPCommandHandler where Handler.Result == Result

    var timeout: TimeInterval { get }
    func tagged(_ tag: String) -> TaggedCommand
}

extension IMAPCommand {

    // MARK: : CustomStringConvertible
    var description: String { fatalError() }
}

protocol IMAPCommandHandler: ChannelInboundHandler, RemovableChannelHandler, Sendable where Result: Sendable {
    associatedtype Result
    init(tag: String, promise: EventLoopPromise<Result>)
    var untaggedResponses: [Response] { get }
    var tag: String { get }
}

/*
class IMAPCommandHandler: @unchecked Sendable {

    typealias InboundIn = Response
    typealias InboundOut = Response
} */
