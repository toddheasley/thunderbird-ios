@testable import Account
import Testing
import Foundation

struct ProcessInfoTests {
    @Test func isTestEnvironment() {
        #expect(ProcessInfo.processInfo.isTestEnvironment == true)
    }
}
