import NIOCore

final class MessageHandler<Decoder: ByteToMessageDecoder>: ChannelInboundHandler, @unchecked Sendable {
    init(_ decoder: Decoder) {
        handler = ByteToMessageHandler(decoder)
    }

    private let handler: ByteToMessageHandler<Decoder>

    // MARK: ChannelInboundHandler
    typealias InboundIn = ByteBuffer
    typealias InboundOut = Decoder.InboundOut

    func handlerAdded(context: ChannelHandlerContext) {
        handler.handlerAdded(context: context)
    }

    func handlerRemoved(context: ChannelHandlerContext) {
        handler.handlerRemoved(context: context)
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        handler.channelRead(context: context, data: data)
    }

    func channelInactive(context: ChannelHandlerContext) {
        handler.channelInactive(context: context)
    }

    func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
        handler.userInboundEventTriggered(context: context, event: event)
    }
}
