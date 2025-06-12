import Testing
@testable import JMAP
import Foundation

struct URLSessionTests {
    @Test(.disabled(if: token.isEmpty)) func jmapAPI() async throws {
        let session: Session = try await URLSession.shared.jmapSession("api.fastmail.com", port: 443, token: token)
        guard let accountID: String = session.accounts.keys.first else {
            throw MethodError.accountNotFound
        }
        let responses: [MethodResponse] = try await URLSession.shared.jmapAPI(
            [
                Mailbox.GetMethod(accountID),
                Mailbox.GetMethod(
                    accountID,
                    ids: [
                        "dc6a40aa-8657-4f74-9aaa-7046ca01325b"
                    ])
            ], url: session.apiURL, token: token
        )
        try #require(responses.count == 2)
        print(String(data: responses[0].data, encoding: .utf8) ?? "nil")
        let mailboxes: [Mailbox] = try responses[0].decode([Mailbox].self)
        for mailbox in mailboxes {
            print(mailbox)
        }
    }

    @Test(.disabled(if: token.isEmpty)) func jmapSession() async throws {
        let session: Session = try await URLSession.shared.jmapSession("api.fastmail.com", port: 443, token: token)
        #expect(session.username.hasSuffix("@fastmail.com") == true)
        print(session.accounts)
    }
}

private let token: String = "fmu1-7a5e4041-b04c0a9ee1409fe514e1cdc0deed8b9b-0-17cbd72a0b45a3bb2884448d699666d5"
