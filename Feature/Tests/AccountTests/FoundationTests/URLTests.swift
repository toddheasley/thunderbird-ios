@testable import Account
import Testing
import Foundation

struct URLTests {
    @Test func accounts() {
        #expect(URL.accounts.absoluteString.hasSuffix("/Accounts.json"))
    }

    @Test func documents() {
        #expect(URL.documents("Test.json").absoluteString.hasSuffix("/Test.json"))
        #expect(URL.documents("Test.txt") == .temporaryDirectory.appending(path: "Test.txt"))
        #expect(URL.documents() == .temporaryDirectory)
    }
}
