@testable import Account
import Testing
import Foundation

struct URLProtectionSpaceTests {
    @Test func account() {
        #expect(URLProtectionSpace.account.host == "thunderbird.net")
    }
}
