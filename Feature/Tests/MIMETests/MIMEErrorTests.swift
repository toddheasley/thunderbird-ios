@testable import MIME
import Testing

struct MIMEErrorTests {

    // MARK: CustomStringConvertible
    @Test func description() {
        #expect(MIMEError.boundaryLength(0).description == "Multipart data boundary length 0 outside of bounds 1...70")
        #expect(MIMEError.boundaryLength(71).description == "Multipart data boundary length 71 outside of bounds 1...70")
        #expect(MIMEError.boundaryNotASCII.description == "Multipart data boundary not ASCII")
        #expect(MIMEError.dataNotDecoded("<data>".data(using: .ascii)!).description == "Multipart data not decodable: <data>")
        #expect(MIMEError.dataNotFound.description == "Multipart data not found")
        #expect(MIMEError.dataNotQuotedPrintable.description == "Multipart data not quoted-printable")
    }
}
