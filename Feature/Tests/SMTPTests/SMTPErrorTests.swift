@testable import SMTP
import Testing

struct SMTPErrorTests {

    // MARK: CustomStringConvertible
    @Test func description() {
        #expect(SMTPError.response("failure-description").description == "Response: failure-description")
    }
}
