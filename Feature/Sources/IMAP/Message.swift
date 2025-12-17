import Foundation
import MIME

/// [IMAP message attributes](https://www.ietf.org/rfc/rfc9051.html#section-2.3)
public struct Message {
    public enum Flag: String, CaseIterable, CustomStringConvertible, Sendable {
        case seen = "\\Seen"
        case answered = "\\Answered"
        case flagged = "\\Flagged"
        case deleted = "\\Deleted"
        case draft = "\\Draft"
        case forwarded = "$Forwarded"
        case mdnSent = "$MDNSent"
        case junk = "$Junk"
        case notJunk = "$NotJunk"
        case phishing = "$Phishing"

        // MARK: CustomStringConvertible
        public var description: String { rawValue }
    }

    public let isDeleted: Bool
    public let folderID: Int
    public let uid: String
    public let subject: String
    public let date: Date
    public let flags: [Flag]
    public let senderList: String
    public let toList: String
    public let ccList: String
    public let bccList: String
    public let replyToList: String
    public let attachmentCount: Int
    public let internalDate: Date
    public let messageID: String
    public let previewType: String
    public let preview: String
    public let mimeType: String
    public let normalizedSubjectHash: Int
    public let isEmpty: Bool
    public let isRead: Bool
    public let isFlagged: Bool
    public let isAnswered: Bool
    public let isForwarded: Bool
    public let messagePartID: Int
    public let encryptionType: String
    public let isNewMessage: Bool
}
