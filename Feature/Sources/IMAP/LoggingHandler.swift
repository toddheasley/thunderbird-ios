import Foundation
import NIOCore
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
        logger?.debug("\(self.unwrapOutboundIn(data).readableLogView(redactBase64Encoded: true))")
        context.write(data, promise: promise)
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        logger?.debug("\(self.unwrapInboundIn(data).readableLogView())")
        context.fireChannelRead(data)
    }
}

extension ByteBuffer {
    // Format bytes as debug description; optionally redact user names and passwords
    func readableLogView(redactBase64Encoded: Bool = false) -> String {
        let string: String = String(decoding: readableBytesView, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
        guard let data: Data = Data(base64Encoded: string),
            let string: String = String(data: data, encoding: .utf8)
        else {
            return string  // String not base64-encoded; return as is
        }
        return redactBase64Encoded ? "[redacted]" : string
    }
}
