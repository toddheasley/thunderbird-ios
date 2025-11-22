@testable import MIME
import Testing

struct CharacterSetTests {
    @Test func ascii() {
        #expect(CharacterSet.ascii.value == "US-ASCII")
    }

    @Test func valueInit() {
        #expect(CharacterSet("ISO-8859-1").value == "ISO-8859-1")
        #expect(CharacterSet("UTF-16🌐") == .ascii)
        #expect(CharacterSet() == .ascii)
    }

    // MARK: RawRepresentable
    @Test func rawValueInit() {
        #expect(CharacterSet(rawValue: "ISO-8859-1")?.value == "ISO-8859-1")
        #expect(CharacterSet(rawValue: "UTF-16🌐") == nil)
        #expect(CharacterSet(rawValue: "") == nil)
    }
}

extension CharacterSetTests {
    @Test func utf8() {
        #expect(CharacterSet.utf8.value == "UTF-8")
    }
}
