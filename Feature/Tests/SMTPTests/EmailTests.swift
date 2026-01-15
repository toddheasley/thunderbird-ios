import Foundation
import MIME
@testable import SMTP
import Testing

struct EmailTests {
    @Test func contentType() {
        #expect(Email.example.contentType == .text(.plain, .ascii))
    }

    @Test func messageID() {
        let id: UUID = UUID(uuidString: "A51D5B17-CA61-4FF1-A4A8-C717289B8F9E")!
        let date: Date = Date(timeIntervalSince1970: 1762463150.82521)
        #expect(Email(sender: "user@example.com", date: date, id: id).messageID == "<1762463150.A51D5B17@example.com>")
        #expect(Email(sender: "abc@", date: date, id: id).messageID == "<1762463150.A51D5B17>")
    }

    @Test func allRecipients() {
        #expect(
            Email.example.allRecipients == [
                "recipient@example.com",
                "no.name@exmaple.com",
                "cc@example.com",
                "bcc@example.com"
            ]
        )
    }
}

extension Email {
    static var example: Self {
        Self(
            sender: "Sender Name <sender@example.com>",
            recipients: [
                "Recipient Name <recipient@example.com>",
                "no.name@exmaple.com"
            ],
            copied: [
                "Copied Recipient <cc@example.com>"
            ],
            blindCopied: [
                "bcc@example.com"
            ],
            subject: "Example email subject",
            date: Date(timeIntervalSince1970: 1762463150.82521),
            body: try! Body("Content-Type: text/plain; charset=\"US-ASCII\"\(crlf)\(crlf)Plain text body content (using only US-ASCII characters)\(crlf)"),
            id: UUID(uuidString: "A51D5B17-CA61-4FF1-A4A8-C717289B8F9E")!
        )
    }
}
