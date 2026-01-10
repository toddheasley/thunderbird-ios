import Foundation
import NIOCore
import NIOIMAPCore
import OSLog

final class LoggingHandler: ChannelDuplexHandler, @unchecked Sendable {
    let logger: Logger?

    init(_ logger: Logger? = nil) {
        self.logger = logger
    }

    // MARK: ChannelDuplexHandler
    typealias InboundIn = ByteBuffer
    typealias OutboundIn = ByteBuffer

    func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        logger?.debug("\(self.unwrapOutboundIn(data).stringValue)")
        context.write(data, promise: promise)  // Handler only observes; pass unmodified data to next handler
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        logger?.debug("\(self.unwrapInboundIn(data).stringValue)")
        context.fireChannelRead(data)  // Pass unmodified data to next handler
    }
}

private extension ByteBuffer {
    var stringValue: String {
        let string: String = String(decoding: readableBytesView, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
        #if DEBUG
        return string
        #else
        return ""  // TODO: Redact IMAP credential when rendering logging; see: NIOIMAPCore.Response.descriptionWithoutPII(responses: Sequence<Response>)
        #endif
    }
}
