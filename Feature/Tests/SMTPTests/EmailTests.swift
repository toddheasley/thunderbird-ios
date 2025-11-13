import Foundation
@testable import SMTP
import Testing

struct EmailTests {
    @Test func body() {
        #expect(String(data: Email.email.body, encoding: .utf8) == emailBody.replacingOccurrences(of: "\n", with: "\r\n"))
    }

    @Test func contentType() {
        #expect(Email.email.contentType == "multipart/alternate; boundary=\"|-----|\"")
    }

    @Test func messageID() {
        let id: UUID = UUID(uuidString: "A51D5B17-CA61-4FF1-A4A8-C717289B8F9E")!
        let date: Date = Date(timeIntervalSince1970: 1762463150.82521)
        #expect(Email(sender: "user@example.com", date: date, id: id).messageID == "<1762463150.A51D5B17@example.com>")
        #expect(Email(sender: "abc@", date: date, id: id).messageID == "<1762463150.A51D5B17>")
    }
}

private extension Email {
    static var email: Self {
        Self(
            sender: "Sender Name <sender@example.com>",
            recipients: [
                "Recipient Name <recipient@example.com>",
                "no.name@exmaple.com"
            ],
            subject: "Example email subject",
            date: Date(timeIntervalSince1970: 1762463150.82521),
            body: [
                "Body content parts can be plain text or <a href=\"https://html.spec.whatwg.org\">HTML</a> -- or included <em>images and other binary data attachments</em>.".data(using: .utf8)!
            ],
            id: UUID(uuidString: "A51D5B17-CA61-4FF1-A4A8-C717289B8F9E")!
        )
    }
}

// swift-format-ignore
private let emailBody: String = """

--|-----|
Body content parts can be plain text or <a href="https://html.spec.whatwg.org">HTML</a> -- or included <em>images and other binary data attachments</em>.
--|-----|--

"""
