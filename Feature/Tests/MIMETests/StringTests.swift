import Foundation
@testable import MIME
import Testing

struct StringTests {
    @Test func crlf() {
        #expect(String.crlf == "\r\n")
    }

    @Test func separator() {
        #expect(String.separator == "-")
    }

    @Test func ascii() {
        #expect("👎 NOT ASCII".ascii == nil)
        #expect("/@scii=12345...".ascii == "/@scii=12345...")
        #expect("".ascii == "")
    }

    @Test func quotedPrintableInit() throws {
        #expect(try String(quotedPrintable: .quotedPrintable) == decodedQuotedPrintable)
        #expect(throws: MIMEError.self) {
            try String(quotedPrintable: .quotedPrintable, encoding: .ascii)
        }
    }

    @Test func decodingQuotedPrintable() throws {
        let quotedPrintable: String = String(data: .quotedPrintable, encoding: .ascii)!
            .replacingOccurrences(of: "=\r\n", with: "")
            .replacingOccurrences(of: "=\n", with: "")
        #expect(try quotedPrintable.decodingQuotedPrintable() == decodedQuotedPrintable)
        #expect(throws: MIMEError.self) {
            try quotedPrintable.decodingQuotedPrintable(to: .ascii)
        }
    }
}

private extension Data {
    static var quotedPrintable: Self { try! Bundle.module.data(forResource: "mime-part.html") }
}

// swift-format-ignore
private let decodedQuotedPrintable: String = """
<!DOCTYPE html>
<style>

    :root {
        color-scheme: light dark;
    }

</style>
<p>HTML MIME part with local <a href="#anchor">⚓️ link</a>, <a href="https://www.thunderbird.net/donate/mobile/?form=tfi">remote link</a> and remote image</p>
<p><img id="anchor" src="https://avatars.githubusercontent.com/u/15187237" alt="Thunderbird avatar"></p>

"""
