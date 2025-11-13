import Network
import NIOCore
import NIOExtras
import NIOSSL
import NIOTLS
import NIOTransportServices

public struct SMTPClient {
    public let server: Server

    public init(_ server: Server, qos: DispatchQoS = .utility) {
        self.server = server
        group = NIOTSEventLoopGroup(loopCount: 1, defaultQoS: qos)
    }

    public func send(_ email: Email) async throws {
        for recipient in email.allRecipients {
            try await send(email, to: recipient)
        }
    }

    func send(_ email: Email, to recipient: EmailAddress) async throws {
        do {
            let done: EventLoopPromise<Void> = group.next().makePromise()
            let bootstrap: NIOClientTCPBootstrap = try .bootstrap(
                email: email,
                recipient: recipient,
                server: server,
                group: group,
                done: done
            )
            let connection: EventLoopFuture<any Channel> = bootstrap.connect(host: server.hostname, port: server.port)
            connection.cascadeFailure(to: done)
            try await withCheckedThrowingContinuation { continuation in
                done.futureResult.map {
                    connection.whenSuccess { $0.close(promise: nil) }
                    continuation.resume()
                }.whenFailure { error in
                    connection.whenSuccess { $0.close(promise: nil) }
                    continuation.resume(throwing: error)
                }
            }
        } catch {
            throw SMTPError(error)
        }
    }

    private let group: EventLoopGroup
}

extension NIOSSLContext {
    static var context: Self { try! Self(configuration: .makeClientConfiguration()) }
}

private extension NIOClientTCPBootstrap {
    static func bootstrap(
        email: Email,
        recipient: EmailAddress,
        server: Server,
        group: EventLoopGroup,
        done: EventLoopPromise<Void>
    ) throws -> Self {
        let bootstrap: NIOClientTCPBootstrap
        switch server.connectionSecurity {
        case .startTLS:
            bootstrap = try NIOClientTCPBootstrap(NIOTSConnectionBootstrap(group: group), tls: NIOSSLClientTLSProvider(context: .context, serverHostname: server.hostname))
        case .tls:
            bootstrap = NIOClientTCPBootstrap(NIOTSConnectionBootstrap(group: group), tls: NIOTSClientTLSProvider())
            bootstrap.enableTLS()
        case .none:
            bootstrap = NIOClientTCPBootstrap(NIOTSConnectionBootstrap(group: group), tls: NIOTSClientTLSProvider())
        }
        return bootstrap.channelInitializer { channel in
            channel.pipeline.addHandlers(
                [
                    LoggingHandler(),
                    MessageHandler(LineBasedFrameDecoder()),
                    ResponseHandler(),
                    ByteHandler(RequestEncoder()),
                    SendHandler(email, recipient: recipient, server: server, done: done)
                ]
            )
        }
    }
}
