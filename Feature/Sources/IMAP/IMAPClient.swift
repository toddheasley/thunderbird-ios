import Foundation
import NIO
@preconcurrency import NIOIMAP
import OSLog

public struct IMAPClient {
    public let server: Server

    public init(
        _ server: Server,
        logger: Logger? = Logger(subsystem: "net.thunderbird.ios", category: "IMAP")
    ) {
        group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.server = server
        self.logger = logger
    }

    private let group: EventLoopGroup
    private let logger: Logger?
}

private extension ClientBootstrap {
    static func bootstrap(
        server: Server,
        logger: Logger? = nil,
        group: EventLoopGroup,
        done: EventLoopPromise<Void>
    ) throws -> Self {
        Self(group: group).channelInitializer { channel in
            channel.pipeline.addHandlers(
                [
                    LoggingHandler(logger),
                    IMAPClientHandler()
                ]

            )
        }
    }
}

// .connect(host: "imap.mail.example.com", port: 993).get()
// try await channel.writeAndFlush(IMAPClientHandler.Message.part(CommandStreamPart.tagged(TaggedCommand(tag: "a001", command: .login(username: "", password: "")))), promise: nil)
