import NIOCore
import NIOIMAP

struct LogoutCommand: IMAPCommand {

    // MARK: IMAPCommand
    typealias Result = Void
    typealias Handler = LogoutHandler

    static var name: String { "logout" }

    func tagged(_ tag: String) -> NIOIMAPCore.TaggedCommand {
        TaggedCommand(tag: tag, command: .logout)
    }
}

class LogoutHandler: IMAPCommandHandler, @unchecked Sendable {

    // MARK: IMAPCommandHandler
    typealias InboundIn = Response
    typealias InboundOut = Response
    typealias Result = Void

    var clientBug: String? = nil
    let promise: EventLoopPromise<Result>
    let tag: String

    required init(tag: String, promise: EventLoopPromise<Result>) {
        self.promise = promise
        self.tag = tag
    }
}
