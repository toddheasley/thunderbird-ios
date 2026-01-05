import NIOCore
@testable import SMTP
import Testing

struct ByteBufferTests {
    @Test func stringValue() {
        #expect(ByteBuffer(string: "334 VXNlcm5hbWU6").stringValue == "334 VXNlcm5hbWU6")
        #expect(ByteBuffer(string: "dXNlcm5hbWVAZXhhbXBsZS5jb20==").stringValue == "username@example.com")
    }
}
