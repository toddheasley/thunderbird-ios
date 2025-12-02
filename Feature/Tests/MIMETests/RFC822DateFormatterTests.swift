import Foundation
@testable import MIME
import Testing

@Test func RFC822DateFormatter() {
    #expect(RFC822DateFormatter().dateFormat == "dd MM yy; hh:mm:ss zzz")
    #expect(RFC822DateFormatter().timeZone == .gmt)
}

struct DateTests {
    @Test func fc822Format() {
        #expect(Date(timeIntervalSince1970: 247158840.0).rfc822Format() == "31 10 77; 03:14:00 GMT")
        #expect(Date(timeIntervalSince1970: 0.0).rfc822Format() == "01 01 70; 12:00:00 GMT")
    }
}
