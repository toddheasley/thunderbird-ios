@testable import IMAP
import Testing

struct IMAPErrorTests {

    // MARK: CustomStringConvertible
    @Test func description() {
        #expect(IMAPError.alreadyConnected.description == "Already connected")
        #expect(IMAPError.notConnected.description == "Not connected")
        #expect(IMAPError.timedOut(seconds: 5).description == "Timed out after 5 seconds")
        #expect(IMAPError.timedOut(seconds: 0).description == "Timed out after 0 seconds")
        #expect(IMAPError.timedOut(seconds: 1).description == "Timed out after 1 second")
    }
}
