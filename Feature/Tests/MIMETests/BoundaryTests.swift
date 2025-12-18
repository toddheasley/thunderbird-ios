import Foundation
@testable import MIME
import Testing

struct BoundaryTests {
    @Test func bounds() {
        #expect(Boundary.bounds == 1...70)
    }

    @Test func descriptionInit() throws {
        let description: String = UUID().uuidString
        #expect(try Boundary(description).description == description)
        #expect(try Boundary("======== ").description == "========")
        #expect(throws: MIMEError.boundaryNotASCII) {
            try Boundary("========👎")
        }
        #expect(throws: MIMEError.boundaryNotASCII) {
            try Boundary(String(repeating: "👎", count: 8))
        }
        #expect(throws: MIMEError.boundaryLength(0)) {
            try Boundary("")
        }
        #expect(throws: MIMEError.boundaryLength(71)) {
            try Boundary(String(repeating: "=", count: 71))
        }
    }
}
