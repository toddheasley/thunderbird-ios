import NIOCore

final class ByteHandler<Encoder: MessageToByteEncoder>: ChannelOutboundHandler, @unchecked Sendable {
    init(_ encoder: Encoder) {
        handler = MessageToByteHandler(encoder)
    }

    private let handler: MessageToByteHandler<Encoder>

    // MARK: ChannelOutboundHandler
    typealias OutboundOut = ByteBuffer
    typealias OutboundIn = Encoder.OutboundIn

    func handlerAdded(context: ChannelHandlerContext) {
        handler.handlerAdded(context: context)
    }

    func handlerRemoved(context: ChannelHandlerContext) {
        handler.handlerRemoved(context: context)
    }

    func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        handler.write(context: context, data: data, promise: promise)
    }

    func flush(context: ChannelHandlerContext) {
        handler.flush(context: context)
    }
}
