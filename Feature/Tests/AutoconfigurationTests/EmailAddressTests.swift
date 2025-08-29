@testable import Autoconfiguration
import Foundation
import Testing

struct EmailAddressTests {
    @Test func host() throws {
        #expect(try "user@example.com".host == "example.com")
        #expect(try "h@x0r@192.168.1.1".host == "192.168.1.1")
        #expect(try "example.com".host == "example.com")
        #expect(throws: URLError.self) {
            try "abc@".host
        }
        #expect(throws: URLError.self) {
            try " ".host
        }
    }

    @Test func local() throws {
        #expect(try "user@example.com".local == "user")
        #expect(try "h@x0r@192.168.1.1".local == "h@x0r")
        #expect(throws: URLError.self) {
            try "example.com".local
        }
    }

    @Test func name() throws {
        #expect(try "user@example.com".name(.autodiscover) == "_autodiscover._tcp.example.com")
        #expect(try "h@x0r@192.168.1.1".name(.imap) == "_imap._tcp.192.168.1.1")
        #expect(try "example.com".name(.smtp) == "_smtp._tcp.example.com")
        #expect(throws: URLError.self) {
            try "abc@".name(.jmap)
        }
    }
}
