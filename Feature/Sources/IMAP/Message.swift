import EmailAddress
import Foundation
import MIME
import NIOIMAP

/// [IMAP message attributes](https://www.ietf.org/rfc/rfc9051.html#section-2.3)
public struct Message {
    public typealias Flag = NIOIMAPCore.Flag

    public let body: Body
    public let contentType: ContentType
    public let flags: [Flag]
    public let folderID: Int
    public let inReplyTo: String?
    public let messageID: String
    public let replyTo: String?
    public let size: Int
    public let subject: String
    public let uid: UID

    public var isAnswered: Bool { flags.isAnswered }
    public var isDeleted: Bool { flags.isDeleted }
    public var isDraft: Bool { flags.isDraft }
    public var isEmpty: Bool { body.isEmpty }
    public var isFlagged: Bool { flags.isFlagged }
    public var isForwarded: Bool { flags.isForwarded }
    public var isSeen: Bool { flags.isSeen }
}

extension Message.Flag: @retroactive CustomStringConvertible {

    // MARK: CustomStringConvertible
    public var description: String { debugDescription }
}

public typealias UID = NIOIMAP.UID

private extension [Message.Flag] {
    var isAnswered: Bool { contains(.answered) }
    var isDeleted: Bool { contains(.deleted) }
    var isDraft: Bool { contains(.draft) }
    var isFlagged: Bool { contains(.flagged) }
    var isForwarded: Bool { contains(.keyword(.forwarded)) }
    var isSeen: Bool { contains(.seen) }
}
