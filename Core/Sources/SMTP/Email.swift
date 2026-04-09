import EmailAddress
import Foundation
import MIME

/// ``SMTPClient`` sends `Email`.
public struct Email: Identifiable, Sendable {
    public let sender: EmailAddress
    public let recipients: [EmailAddress]
    public let copied: [EmailAddress]
    public let blindCopied: [EmailAddress]
    public let subject: String
    public let date: Date
    public let body: Body

    public var contentType: MIME.ContentType { body.contentType }

    public var messageID: String {
        // Format: https://www.jwz.org/doc/mid.html
        let local: String = "\(Int(date.timeIntervalSince1970)).\(id.uuidString(1))"
        guard let host: String = sender.host else {
            return "<\(local)>"
        }
        return "<\(local)@\(host)>"
    }

    public init(
        sender: EmailAddress,
        recipients: [EmailAddress] = [],
        copied: [EmailAddress] = [],
        blindCopied: [EmailAddress] = [],
        subject: String = "",
        date: Date = Date(),
        body: Body = .empty,
        id: UUID = UUID()
    ) {
        self.sender = sender
        self.recipients = recipients
        self.copied = copied
        self.blindCopied = blindCopied
        self.subject = subject
        self.date = date
        self.body = body
        self.id = id
    }

    var allRecipients: [EmailAddress] { recipients + copied + blindCopied }

    // MARK: Identifiable
    public let id: UUID
}
