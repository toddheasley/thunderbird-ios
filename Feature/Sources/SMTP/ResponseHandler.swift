import NIOCore

enum Response {
    case ok(Int, String)
    case error(String)
}

final class ResponseHandler: ChannelInboundHandler, Sendable {

    // MARK: ChannelInboundHandler
    typealias InboundIn = ByteBuffer
    typealias InboundOut = Response

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var buffer: ByteBuffer = unwrapInboundIn(data)
        guard let prefix: String = buffer.readString(length: 4),
            let code: Int = Int(prefix.dropLast())
        else {
            context.fireErrorCaught(SMTPError.responseNotDecoded)
            return
        }
        let string: String = buffer.readString(length: buffer.readableBytes) ?? ""
        switch (prefix.first!, prefix.last!) {
        case ("2", " "), ("3", " "):
            context.fireChannelRead(wrapInboundOut(.ok(code, string)))
        case (_, "-"):
            break  // Ignore messages except OK and error
        default:
            context.fireChannelRead(wrapInboundOut(.error("\(prefix)\(string)")))
        }
    }
}
