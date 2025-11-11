import Foundation
import NIOCore

final class LoggingHandler: ChannelDuplexHandler, @unchecked Sendable {
    init(_ logger: @escaping (String) -> Void) {
        self.logger = logger
    }

    private let logger: (String) -> Void

    // MARK: ChannelDuplexHandler
    typealias InboundIn = ByteBuffer
    typealias OutboundIn = ByteBuffer

    func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        let buffer: ByteBuffer = unwrapOutboundIn(data)
        let string: String = String(decoding: buffer.readableBytesView, as: UTF8.self)
        if buffer.readableBytesView.starts(with: Data("password".utf8).base64EncodedData()) {
            logger(String(repeating: "•", count: string.count))  // Redact password from logging
        } else {
            logger(string)
        }
        context.write(data, promise: promise)
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        logger(String(decoding: unwrapInboundIn(data).readableBytesView, as: UTF8.self))
        context.fireChannelRead(data)
    }
}
