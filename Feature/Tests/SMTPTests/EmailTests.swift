import Foundation
@testable import SMTP
import Testing

struct EmailTests {
    @Test func body() {
        #expect(String(data: Email.email.body, encoding: .utf8) == emailBody.replacingOccurrences(of: "\n", with: "\r\n"))
    }

    @Test func contentType() {
        #expect(Email.email.contentType == "text/plain; charset=\"UTF-8\"")
    }

    @Test func messageID() {
        let id: UUID = UUID(uuidString: "A51D5B17-CA61-4FF1-A4A8-C717289B8F9E")!
        let date: Date = Date(timeIntervalSince1970: 1762463150.82521)
        #expect(Email(sender: "user@example.com", date: date, id: id).messageID == "<1762463150.A51D5B17@example.com>")
        #expect(Email(sender: "abc@", date: date, id: id).messageID == "<1762463150.A51D5B17>")
    }

    @Test func iso8601Date() {
        #expect(Email.email.iso8601Date == "2025-11-06T21:05:50Z")
    }

    @Test func allRecipients() {
        #expect(
            Email.email.allRecipients == [
                "recipient@example.com",
                "no.name@exmaple.com",
                "cc@example.com",
                "bcc@example.com"
            ]
        )
    }

    @Test func dataBoundary() {
        #expect(Email.email.dataBoundary == "A51D5B17-CA61-4FF1-A4A8_part")
    }
}

struct UUIDTests {
    @Test func uuidString() {
        #expect(Email.email.id.uuidString == "A51D5B17-CA61-4FF1-A4A8-C717289B8F9E")
        #expect(Email.email.id.uuidString(-2) == "")
        #expect(Email.email.id.uuidString(0) == "")
        #expect(Email.email.id.uuidString(1) == "A51D5B17")
        #expect(Email.email.id.uuidString(2) == "A51D5B17-CA61")
        #expect(Email.email.id.uuidString(3) == "A51D5B17-CA61-4FF1")
        #expect(Email.email.id.uuidString(4) == "A51D5B17-CA61-4FF1-A4A8")
        #expect(Email.email.id.uuidString(5) == "A51D5B17-CA61-4FF1-A4A8-C717289B8F9E")
        #expect(Email.email.id.uuidString(99) == "A51D5B17-CA61-4FF1-A4A8-C717289B8F9E")
    }
}

struct StringTests {
    @Test func line() {
        #expect(String.line == "\r\n")
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
            copied: [
                "Copied Recipient <cc@example.com>"
            ],
            blindCopied: [
                "bcc@example.com"
            ],
            subject: "Example email subject",
            date: Date(timeIntervalSince1970: 1762463150.82521),
            body: [
                "Body content parts can be plain text for now ;)".data(using: .utf8)!
            ],
            id: UUID(uuidString: "A51D5B17-CA61-4FF1-A4A8-C717289B8F9E")!
        )
    }
}

// swift-format-ignore
private let emailBody: String = """

Body content parts can be plain text for now ;)

"""
