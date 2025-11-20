@testable import MIME
import Testing

struct MIMEErrorTests {

    // MARK: CustomStringConvertible
    @Test func description() {
        #expect(MIMEError.boundaryLength(0).description == "Multipart data boundary length 0 outside of bounds 1...70")
        #expect(MIMEError.boundaryLength(71).description == "Multipart data boundary length 71 outside of bounds 1...70")
        #expect(MIMEError.boundaryNotASCII.description == "Multipart data boundary not ASCII")
    }
}
