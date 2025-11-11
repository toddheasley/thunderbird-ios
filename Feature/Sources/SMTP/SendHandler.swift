import NIOCore
import NIOSSL
import NIOFoundationCompat

final class SendHandler: ChannelInboundHandler, @unchecked Sendable {
    let email: Email
    let server: Server

    init(_ email: Email, server: Server, done: EventLoopPromise<Void>) {
        self.email = email
        self.server = server
        self.done = done
    }

    private enum Expect {
        case initialMessageFromServer
        case okForHello
        case okForStartTLS
        case tlsHandlerToBeAdded
        case okForAuthBegin
        case okAfterUsername
        case okAfterPassword
        case okAfterMailFrom
        case okAfterRecipient
        case okAfterData
        case okAfterTransferData
        case okAfterQuit
        case nothing
        case error(Error)
    }

    private let done: EventLoopPromise<Void>
    private var context: ChannelHandlerContext?

    private var expect: Expect = .initialMessageFromServer {
        didSet {
            guard case .error(let error) = expect else { return }
            done.fail(error)
        }
    }

    private func send(context: ChannelHandlerContext, command: Request) {
        context.writeAndFlush(wrapOutboundOut(command)).cascadeFailure(to: done)
    }

    private func sendAuthLogin() {
        @Sendable func send() {
            guard let context else { return }
            self.send(context: context, command: .authLogin)
            expect = .okForAuthBegin
        }

        switch server.connectionSecurity {
        case .startTLS, .tls:
            if let context {
                context.channel.pipeline.handler(type: NIOSSLClientHandler.self).map { _ in
                    send()  // SSL handler present in pipeline
                }.whenFailure { error in
                    guard self.server.connectionSecurity == .tls else { return }
                    self.expect = .error(error)
                }
            } else {
                expect = .error(ChannelError.inappropriateOperationForState)
            }
        case .none:
            send()  // Authenticate in plain text
        }
    }

    // MARK: ChannelInboundHandler
    typealias OutboundIn = Email
    typealias OutboundOut = Request
    typealias InboundIn = Response

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        switch unwrapInboundIn(data) {
        case .error(let error):
            print(error)
            done.fail(ChannelError.operationUnsupported)
        case .ok:
            switch expect {
            case .initialMessageFromServer:
                send(context: context, command: .hello(server.hostname))
                expect = .okForHello
            case .okForHello:
                switch server.connectionSecurity {
                case .startTLS:
                    send(context: context, command: .startTLS)
                    expect = .okForStartTLS
                case .tls, .none:
                    self.context = context
                    sendAuthLogin()
                }
            case .okForStartTLS:
                expect = .tlsHandlerToBeAdded
                self.context = context
                context.channel.eventLoop.makeCompletedFuture {
                    try context.channel.pipeline.syncOperations.addHandler(
                        try NIOSSLClientHandler(context: .context, serverHostname: server.hostname),
                        position: .first
                    )
                }.whenComplete { result in
                    switch self.expect {
                    case .tlsHandlerToBeAdded:
                        switch result {
                        case .failure(let error):
                            self.expect = .error(error)
                        case .success:
                            self.sendAuthLogin()
                        }
                        break
                    default:
                        self.expect = .error(ChannelError.inappropriateOperationForState)
                    }
                }
            case .tlsHandlerToBeAdded:
                expect = .error(ChannelError.inputClosed)
            case .okForAuthBegin:
                send(context: context, command: .authUser(server.username))
                expect = .okAfterUsername
            case .okAfterUsername:
                send(context: context, command: .authPassword(server.password))
                expect = .okAfterPassword
            case .okAfterPassword:
                send(context: context, command: .mailFrom(email.sender))
                expect = .okAfterMailFrom
            case .okAfterMailFrom:
                if let recipient: EmailAddress = email.recipients.first {
                    send(context: context, command: .recipient(recipient))
                    expect = .okAfterRecipient
                } else {
                    expect = .error(ChannelError.unknownLocalAddress)
                }
            case .okAfterRecipient:
                send(context: context, command: .data)
                expect = .okAfterData
            case .okAfterData:
                send(context: context, command: .transferData(email))
                expect = .okAfterTransferData
            case .okAfterTransferData:
                send(context: context, command: .quit)
                expect = .okAfterQuit
            case .okAfterQuit:
                done.succeed()
                context.close(promise: nil)
                expect = .nothing
            case .nothing:
                break
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    func channelInactive(context: ChannelHandlerContext) {
        done.fail(ChannelError.eof)
    }

    func errorCaught(context: ChannelHandlerContext, error: any Error) {
        expect = .error(error)
        done.fail(error)
        context.close(promise: nil)
    }
}
