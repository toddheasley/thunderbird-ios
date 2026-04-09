import Foundation
@testable import MIME
import Testing

struct ContentTransferEncodingTests {

    // MARK: RawRepresentable
    @Test func rawValueInit() {
        #expect(ContentTransferEncoding(rawValue: "7BIT") == .ascii)
        #expect(ContentTransferEncoding(rawValue: " base64") == .base64)
        #expect(ContentTransferEncoding(rawValue: "binary") == .binary)
        #expect(ContentTransferEncoding(rawValue: "8bit") == .data)
        #expect(ContentTransferEncoding(rawValue: "QUOTED-PRINTABLE") == .quotedPrintable)
        #expect(ContentTransferEncoding(rawValue: "16bit") == nil)
    }
}
