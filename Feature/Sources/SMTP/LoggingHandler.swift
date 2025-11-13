import Foundation
import NIOCore
import OSLog

final class LoggingHandler: ChannelDuplexHandler, @unchecked Sendable {

    // MARK: ChannelDuplexHandler
    typealias InboundIn = ByteBuffer
    typealias OutboundIn = ByteBuffer

    func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        let buffer: ByteBuffer = unwrapOutboundIn(data)
        let string: String = String(decoding: buffer.readableBytesView, as: UTF8.self)
        // TODO: Replace console printing with OS logger
        if buffer.readableBytesView.starts(with: Data("password".utf8).base64EncodedData()) {
            print(String(repeating: "•", count: string.count))  // Redact password from logging
        } else {
            print(string)
        }
        context.write(data, promise: promise)
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        // TODO: Replace console printing with OS logger
        print(String(decoding: unwrapInboundIn(data).readableBytesView, as: UTF8.self))
        context.fireChannelRead(data)
    }
}
