import Foundation
import NIOCore
@testable import IMAP
import Testing

struct ByteBufferTests {
    @Test func readableSMTPView() {
        #expect(ByteBuffer(string: "334 VXNlcm5hbWU6").readableLogView() == "334 VXNlcm5hbWU6")
        #expect(ByteBuffer(string: "334 VXNlcm5hbWU6").readableLogView(redactBase64Encoded: true) == "334 VXNlcm5hbWU6")
        #expect(ByteBuffer(string: "dXNlcm5hbWVAZXhhbXBsZS5jb20==").readableLogView() == "username@example.com")
        #expect(ByteBuffer(string: "dXNlcm5hbWVAZXhhbXBsZS5jb20==").readableLogView(redactBase64Encoded: true) == "[redacted]")
    }
}
