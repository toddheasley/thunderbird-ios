import Foundation
import MIME
@testable import SMTP
import Testing

struct SMTPClientTests {
    @Test(.disabled(if: Server.server.password.isEmpty)) func send() async throws {
        try await SMTPClient(.server).send(.email)
    }

    @Test(.disabled(if: Server.server.password.isEmpty)) func sendToRecipient() async throws {
        try await SMTPClient(.server).send(.email, to: "recipient@example.com")
    }
}

private extension Email {
    static var email: Self {
        Self(
            sender: "sender@example.com",
            recipients: [
                "recipient@example.com"
            ],
            subject: "Example email subject",
            body: try! Body(parts: [
                Part(data: "For a brief period of time, email body contents were made of plain, ASCII text only :)".data(using: .ascii)!, contentType: .text(.plain, .ascii))
            ]),
            id: UUID(uuidString: "A51D5B17-CA61-4FF1-A4A8-C717289B8F9E")!
        )
    }
}

// Catch when password is being leaked
@Test func emptyPassword() {
    #expect(Server.server.password == "")
}

private extension Server {
    static var server: Self {
        Self(
            .startTLS,
            hostname: "",
            username: "",
            password: "",
            port: 587
        )
    }
}
