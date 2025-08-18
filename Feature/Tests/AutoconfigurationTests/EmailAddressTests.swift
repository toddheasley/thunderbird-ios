@testable import Autoconfiguration
import Testing
import Foundation

struct EmailAddressTests {
    @Test func host() throws {
        #expect(try "user@example.com".host == "example.com")
        #expect(try "h@x0r@192.168.1.1".host == "192.168.1.1")
        #expect(try "example.com".host == "example.com")
        #expect(throws: URLError.self) {
            try " ".host
        }
    }
}
