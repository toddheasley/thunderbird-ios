import Testing
@testable import JMAP
import Foundation

struct URLSessionTests {
    @Test(.disabled(if: token.isEmpty)) func jmapAPI() async throws {
        let session: Session = try await URLSession.shared.jmapSession("api.fastmail.com", port: 443, token: token)
        guard let accountID: String = session.accounts.keys.first else {
            throw MethodError.accountNotFound
        }
        let results = try await URLSession.shared.jmapAPI(
            [
                Mailbox.GetMethod(accountID),
                Mailbox.GetMethod(
                    accountID,
                    ids: [
                        "dc6a40aa-8657-4f74-9aaa-7046ca01325b"
                    ])
            ], url: session.apiURL, token: token
        )
    }

    @Test(.disabled(if: token.isEmpty)) func jmapSession() async throws {
        let session: Session = try await URLSession.shared.jmapSession("api.fastmail.com", port: 443, token: token)
        #expect(session.username.hasSuffix("@fastmail.com") == true)
        print(session.accounts)
    }
}

private let token: String = ""
