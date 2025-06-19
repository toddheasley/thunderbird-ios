import Testing
@testable import JMAP
import Foundation

struct URLSessionTests {
    @Test(.disabled(if: token.isEmpty)) func jmapAPI() async throws {
        let session: Session = try await URLSession.shared.jmapSession("api.fastmail.com", port: 443, token: token)
        guard let accountID: String = session.accounts.keys.first else {
            throw MethodError.accountNotFound
        }
        /*
        let responses: [any MethodResponse] = try await URLSession.shared.jmapAPI(
            [
                /* Mailbox.GetMethod(accountID),
                 Mailbox.GetMethod(
                 accountID,
                 ids: [
                 "dc6a40aa-8657-4f74-9aaa-7046ca01325b"
                 ]), */
                Mailbox.SetMethod(
                    accountID,
                    actions: [
                        /*
                         .create([
                         "\(UUID().uuidString)": [
                         "name": "Test",
                         "parentId": "dc6a40aa-8657-4f74-9aaa-7046ca01325b"
                         ] */
                        .destroy([
                            "56df4f67-3b66-4fe4-b013-45afcf160d37"
                        ])
                    ])
            ], url: session.apiURL, token: token
        )
        
        print(responses)
        
        // try #require(responses.count == 3)
        guard let response: MethodGetResponse = responses[0] as? MethodGetResponse else {
            throw MethodError.invalidResultReference
        }
        print(String(data: response.data, encoding: .utf8) ?? "nil")
        let mailboxes: [Mailbox] = try response.decode([Mailbox].self)
        for mailbox in mailboxes {
            print(mailbox)
        } */
    }

    @Test(.disabled(if: token.isEmpty)) func jmapSession() async throws {
        let session: Session = try await URLSession.shared.jmapSession("api.fastmail.com", port: 443, token: token)
        #expect(session.username.hasSuffix("@fastmail.com") == true)
        print(session.accounts)
    }
}

// Catch when token is being leaked
@Test func emptyToken() {
    #expect(token == "")
}

private let token: String = ""
