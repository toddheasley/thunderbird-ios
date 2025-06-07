import Testing
@testable import JMAP
import Foundation

struct URLSessionTests {
    @Test(.disabled(if: token.isEmpty)) func session() async throws {
        let session: Session = try await URLSession.shared.session("api.fastmail.com", token: token)
        #expect(session.username == "toddheasley@fastmail.com")
    }
}

private let token: String = ""
