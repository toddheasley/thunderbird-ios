import Foundation
import MIME
@testable import SMTP
import Testing

struct SMTPClientTests {
    @Test(.disabled(if: Server.server.password.isEmpty)) func send() async throws {
        let client: SMTPClient = SMTPClient(.server)
        do {
            try await client.send(.email)
        } catch {
            print(error)
        }
    }

    @Test(.disabled(if: Server.server.password.isEmpty)) func sendToRecipient() async throws {
        let client: SMTPClient = SMTPClient(.server)
        do {
            try await client.send(.email, to: "")
        } catch {
            print(error)
        }
    }
}

private extension Email {
    static var email: Self {
        Self(
            sender: "",
            recipients: [
                ""
            ],
            subject: "Example email subject",
            body: .empty,
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
