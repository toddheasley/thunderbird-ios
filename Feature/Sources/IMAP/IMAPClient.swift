import Foundation
import NIO
import NIOIMAP
import NIOSSL
import OSLog

/// Configure `IMAPClient` with a single ``Server``.
public class IMAPClient {
    public var capabilities: Set<NIOIMAPCore.Capability> = []
    public let server: Server

    public var isConnected: Bool { channel != nil && channel!.isActive }

    public func connect() async throws {
        logger?.info("Connecting to \(self.server)…")
        resetInactiveChannel()
        guard channel == nil else {
            logger?.error("\(IMAPError.alreadyConnected)")
            throw IMAPError.alreadyConnected
        }
        do {
            self.channel =
                try await ClientBootstrap
                .bootstrap(server: server, logger: logger, group: group)
                .connect(host: server.hostname, port: server.port)
                .get()
            logger?.info("Connected to \(self.server)")
            try await refreshCapabilities()
        } catch {
            logger?.error("\(error)")
            throw IMAPError(error)
        }
    }

    public func login() async throws {
        try await login(username: server.username, password: server.password)
    }

    public func login(username: String, password: String) async throws {
        guard let channel, channel.isActive else {
            throw IMAPError.notConnected
        }
        let command: TaggedCommand = TaggedCommand(tag: "a001", command: .login(username: username, password: password))
        let part: CommandStreamPart = .tagged(command)
        try await channel.writeAndFlush(IMAPClientHandler.OutboundIn.part(part)).get()
    }

    public func disconnect() throws {
        guard let channel else {
            logger?.error("\(IMAPError.notConnected)")
            throw IMAPError.notConnected
        }
        channel.close(promise: nil)
        self.channel = nil
    }

    public init(
        _ server: Server,
        logger: Logger? = Logger(subsystem: "net.thunderbird", category: "IMAP")
    ) {
        group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.server = server
        self.logger = logger
    }

    static func tag(_ count: Int, prefix: Character = .prefix) -> String {
        "\(prefix)\(String(format: "%03d", min(max(count, 1), 999)))"
    }

    func tag(prefix: Character = .prefix) -> String {
        count = count > 998 ? 1 : count + 1  // Auto-increment tag count; roll back to 1 after 999
        return Self.tag(count, prefix: prefix)
    }

    func execute<T: IMAPCommand>(command: T) async throws -> T.Result {
        let logger: Logger? = logger
        logger?.info("Executing \(command)…")
        if !isConnected {  // Reconnect automagically
            try await connect()
        }
        guard let channel, channel.isActive else {
            throw IMAPError.notConnected
        }
        let promise: EventLoopPromise<T.Result> = channel.eventLoop.makePromise(of: T.Result.self)
        let tag: String = tag()  // Hold onto specific auto-generated tag
        let handler: T.Handler = T.Handler(tag: tag, promise: promise)
        let seconds: Int64 = max(command.timeout, 1)
        let task: Scheduled = group.next().scheduleTask(in: .seconds(seconds)) {
            let error: IMAPError = .timedOut(seconds: seconds)
            logger?.error("\(error)")
            promise.fail(error)
        }
        defer {
            task.cancel()
        }
        do {
            try await channel.pipeline.addHandler(handler).get()
            let message: IMAPClientHandler.Message = IMAPClientHandler.OutboundIn.part(.tagged(command.tagged(tag)))
            try await channel.writeAndFlush(message).get()
            let result: T.Result = try await promise.futureResult.get()
            if let clientBug = handler.clientBug {
                logger?.debug("CLIENTBUG: \(clientBug)")
            }
            logger?.debug("")

            return result
        } catch {
            promise.fail(error)
            throw IMAPError.commandFailed(command.description)
        }
    }

    func refreshCapabilities() async throws {
        capabilities = Set(try await execute(command: CapabilityCommand()))
    }

    func resetInactiveChannel() {
        guard let channel, !channel.isActive else { return }
        self.channel = nil
    }

    private var channel: Channel?
    private var count: Int = 0
    private let group: EventLoopGroup
    private let logger: Logger?
}

extension Character {
    static let prefix: Self = "a"
}

private extension ClientBootstrap {
    static func bootstrap(
        server: Server,
        logger: Logger? = nil,
        group: EventLoopGroup
    ) -> Self {
        Self(group: group).channelInitializer { channel in
            try! channel.pipeline.syncOperations.addHandlers(
                [
                    LoggingHandler(logger),
                    TLSClientHandler(serverHostname: server.hostname),
                    IMAPClientHandler(parserOptions: .max)
                ]
            )
            return channel.eventLoop.makeSucceededFuture(())
        }
    }
}

private extension NIOSSLContext {
    static var ssl: Self { try! Self(configuration: .makeClientConfiguration()) }
}

private func TLSClientHandler(serverHostname: String? = nil) -> NIOSSLClientHandler {
    try! NIOSSLClientHandler(context: .ssl, serverHostname: serverHostname)
}

private extension ResponseParser.Options {
    static var max: Self {
        Self(
            bufferLimit: 1024 * 1024,
            messageAttributeLimit: .max,
            bodySizeLimit: .max,
            literalSizeLimit: IMAPDefaults.literalSizeLimit
        )
    }
}
