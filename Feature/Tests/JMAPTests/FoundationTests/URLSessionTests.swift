import Testing
@testable import JMAP
import Foundation

struct URLSessionTests {
    @Test(.disabled(if: token.isEmpty)) func jmapAPI() async throws {
        let session: Session = try await URLSession.shared.jmapSession("api.fastmail.com", port: 443, token: token)
        guard let accountID: String = session.accounts.keys.first else {
            throw MethodError.accountNotFound
        }
        let responses: [any MethodResponse] = try await URLSession.shared.jmapAPI(
            [
                Mailbox.GetMethod(accountID)
            ],
            url: session.apiURL,
            token: token
        )
        try #require(responses.count == 1)
        guard let response: MethodGetResponse = responses[0] as? MethodGetResponse else {
            throw MethodError.invalidArguments
        }
        let mailboxes: [Mailbox] = try response.decode([Mailbox].self)
        #expect(mailboxes.count > 0)
    }

    @Test(.disabled(if: token.isEmpty)) func jmapSession() async throws {
        let session: Session = try await URLSession.shared.jmapSession("api.fastmail.com", port: 443, token: token)
        #expect(session.username.hasSuffix("@fastmail.com") == true)
    }
}

// Catch when token is being leaked
@Test func emptyToken() {
    #expect(token == "")
}

private let token: String = ""
