@testable import MIME
import Testing

struct CharacterSetTests {
    @Test func ascii() {
        #expect(CharacterSet.ascii.rawValue == "US-ASCII")
    }

    @Test func descriptionInit() throws {
        #expect(try CharacterSet("ISO-8859-1").rawValue == "ISO-8859-1")
        #expect(try CharacterSet().rawValue == "US-ASCII")
        #expect(throws: MIMEError.self) {
            try CharacterSet("UTF-16🌐")
        }
    }
}

extension CharacterSetTests {
    @Test func utf8() {
        #expect(CharacterSet.utf8.rawValue == "UTF-8")
    }
}
