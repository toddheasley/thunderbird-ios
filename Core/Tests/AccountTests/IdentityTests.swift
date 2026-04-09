@testable import Account
import Testing
import Foundation

struct IdentityTests {
    @Test func description() {
        #expect(Identity("user@example.com", displayName: "$").description == "$ <user@example.com>")
        #expect(Identity("user@example.com", displayName: "Example User").description == "Example User <user@example.com>")
        #expect(Identity("user@example.com", displayName: "").description == "user@example.com")
        #expect(Identity("user@example.com").description == "user@example.com")
    }
}
