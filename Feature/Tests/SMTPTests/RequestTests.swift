import Foundation
import NIOCore
@testable import SMTP
import Testing

struct RequestEncoderTests {
    @Test func encode() throws {
        var buffer: ByteBuffer = ByteBuffer()
        try RequestEncoder().encode(data: .hello("smtp.example.com"), out: &buffer)
        #expect(buffer.readString(length: buffer.readableBytes) == "EHLO smtp.example.com\r\n")
        try RequestEncoder().encode(data: .startTLS, out: &buffer)
        #expect(buffer.readString(length: buffer.readableBytes) == "STARTTLS\r\n")
        try RequestEncoder().encode(data: .authLogin, out: &buffer)
        #expect(buffer.readString(length: buffer.readableBytes) == "AUTH LOGIN\r\n")
        try RequestEncoder().encode(data: .authUser("user@example.com"), out: &buffer)
        #expect(buffer.readString(length: buffer.readableBytes) == "dXNlckBleGFtcGxlLmNvbQ==\r\n")
        try RequestEncoder().encode(data: .authPassword("P@s$W0rd"), out: &buffer)
        #expect(buffer.readString(length: buffer.readableBytes) == "UEBzJFcwcmQ=\r\n")
        try RequestEncoder().encode(data: .mailFrom("Sender Name <sender@example.com>"), out: &buffer)
        #expect(buffer.readString(length: buffer.readableBytes) == "MAIL FROM:<sender@example.com>\r\n")
        try RequestEncoder().encode(data: .recipient("Recipient Name <recipient@example.com>"), out: &buffer)
        #expect(buffer.readString(length: buffer.readableBytes) == "RCPT TO:<recipient@example.com>\r\n")
        try RequestEncoder().encode(data: .data, out: &buffer)
        #expect(buffer.readString(length: buffer.readableBytes) == "DATA\r\n")
        try RequestEncoder().encode(data: .transferData(.email), out: &buffer)
        #expect(buffer.readString(length: buffer.readableBytes) == "\(emailBody.replacingOccurrences(of: "\n", with: "\r\n"))\r\n")
        try RequestEncoder().encode(data: .quit, out: &buffer)
        #expect(buffer.readString(length: buffer.readableBytes) == "QUIT\r\n")
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
From: Sender Name <sender@example.com>
To: Recipient Name <recipient@example.com> no.name@exmaple.com
Date: 2025-11-06T21:05:50Z
Message-ID: <1762463150.A51D5B17@example.com>
Subject: Example email subject
MIME-Version: 1.0
Content-type: multipart/alternate; boundary=""

.
"""
