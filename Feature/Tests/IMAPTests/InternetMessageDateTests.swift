import Foundation
@testable import IMAP
import MIME
import NIOIMAPCore
import Testing

struct InternetMessageDateTests {
    // internetMessageDate
}

struct TimeZoneTests {
    @Test func internetMessageDateInit() throws {
        #expect(try TimeZone(internetMessageDate: "Tue, 28 Nov 2023 08:55:43 -0800") == TimeZone(secondsFromGMT: -800))
        #expect(try TimeZone(internetMessageDate: "Fri, 23 Jan 2026 13:23:47 +0000 (UTC)") == .gmt)
        #expect(try TimeZone(internetMessageDate: "Tue, 28 Nov 2023 08:55:43-0500") == TimeZone(secondsFromGMT: -500))
        #expect(try TimeZone(internetMessageDate: "Tue, 28 Nov 2023 08:55:43+0700") == TimeZone(secondsFromGMT: 700))
        #expect(try TimeZone(internetMessageDate: "Sun, 25 Jan 2026 10:21:49 GMT") == .gmt)
    }
}
