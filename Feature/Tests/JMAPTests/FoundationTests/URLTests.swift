import Testing
@testable import JMAP
import Foundation

struct URLTests {
    @Test func session() throws {
        #expect(try URL.session("api.fastmail.com").absoluteString == "https://api.fastmail.com/jmap/session")
        #expect(throws: URLError.self) {
            try URL.session("")
        }
    }

    @Test func jmap() throws {
        #expect(try URL.jmap("api.fastmail.com").absoluteString == "https://api.fastmail.com")
        #expect(try URL.jmap("api.fastmail.com", path: "/jmap/session").absoluteString == "https://api.fastmail.com/jmap/session")
        #expect(try URL.jmap("api.fastmail.com", path: "jmap/session").absoluteString == "https://api.fastmail.com/jmap/session")
        #expect(throws: URLError.self) {
            try URL.jmap("")
        }
    }
}
