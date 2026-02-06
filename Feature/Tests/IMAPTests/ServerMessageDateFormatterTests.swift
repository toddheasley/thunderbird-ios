import Foundation
@testable import IMAP
import MIME
import NIOIMAPCore
import Testing

struct ServerMessageDateFormatterTests {
    @Test func dateFormat() {
        #expect(ServerMessageDateFormatter().dateFormat == "dd-MMM-yyyy HH:mm:ss +0000")
    }

    @Test func string() {
        #expect(ServerMessageDateFormatter().string(from: Date(timeIntervalSince1970: 247133640.0)) == "31-Oct-1977 08:14:00 +0000")
    }

    @Test func date() throws {
        let formatter: ServerMessageDateFormatter = ServerMessageDateFormatter()
        #expect(try formatter.date(from: "31-Oct-1977 08:14:00 +0000") == Date(timeIntervalSince1970: 247133640.0))
        #expect(try formatter.date(from: "\"31-Oct-1977 08:14:00") == Date(timeIntervalSince1970: 247133640.0))
        #expect(throws: MIMEError.self) {
            try formatter.date(from: "31 10 77; 03:14:00 GMT")
        }
    }
}
