@testable import MIME
import Testing

struct ContentTypeTests {
    @Test func subType() {
        #expect(ContentType.application("zip").subType == "zip")
        #expect(ContentType.image("png").subType == "png")
        #expect(ContentType.multipart(.mixed).subType == "mixed")
        #expect(ContentType.text("html").subType == "html")
    }

    @Test func isMultipart() {
        #expect(ContentType.multipart(.mixed).isMultipart == true)
        #expect(ContentType.image("heic").isMultipart == false)
    }

    @Test func boundary() {
        #expect(ContentType.multipart(.mixed).boundary?.description.count == 36)  // UUID string default
        #expect(ContentType.multipart(.mixed).boundary?.description.components(separatedBy: "-").count == 5)
        #expect(ContentType.text("html", .ascii).boundary == nil)

    }

    @Test func charset() {
        #expect(ContentType.text("html", .utf8).charset == .utf8)
        #expect(ContentType.text("plain", .ascii).charset == .ascii)
        #expect(ContentType.image("tiff").charset == nil)
    }

    @Test func value() {
        #expect(ContentType.application("").value == "application")
        #expect(ContentType.audio("").value == "audio")
        #expect(ContentType.example("").value == "example")
        #expect(ContentType.font("").value == "font")
        #expect(ContentType.haptics("").value == "haptics")
        #expect(ContentType.image("").value == "image")
        #expect(ContentType.message("").value == "message")
        #expect(ContentType.model("").value == "model")
        #expect(ContentType.multipart("").value == "multipart")
        #expect(ContentType.text("").value == "text")
        #expect(ContentType.video("").value == "video")
    }

    // MARK: RawRepresentable
    @Test func rawValue() {
        #expect(ContentType.application("zip").rawValue == "application/zip")
        #expect(ContentType.image("png").rawValue == "image/png")
        #expect(ContentType.multipart(.mixed, try! Boundary("5A8AE6FB")).rawValue == "multipart/mixed; boundary=\"5A8AE6FB\"")
        #expect(ContentType.text("plain", .ascii).rawValue == "text/plain; charset=\"US-ASCII\"")
        #expect(ContentType.text("html").rawValue == "text/html")
    }

    @Test func rawValueInit() {
        #expect(ContentType(rawValue: "application/zip") == .application("zip"))
        #expect(ContentType(rawValue: "audio/aac") == .audio("aac"))
        #expect(ContentType(rawValue: "example/foo ") == .example("foo"))
        #expect(ContentType(rawValue: "font/otf") == .font("otf"))
        #expect(ContentType(rawValue: "haptics/FOO") == .haptics("FOO"))
        #expect(ContentType(rawValue: "image/png") == .image("png"))
        #expect(ContentType(rawValue: "message/ex") == .message("ex"))
        #expect(ContentType(rawValue: "MODEL/EX") == .model("EX"))
        #expect(ContentType(rawValue: "multipart/mixed; boundary=\"5A8AE6FB\"") == .multipart(.mixed, try! Boundary("5A8AE6FB")))
        #expect(ContentType(rawValue: "text/html; charset=\"UTF-8\"") == .text("html", .utf8))
        #expect(ContentType(rawValue: "text/plain") == .text("plain"))
        #expect(ContentType(rawValue: "video/mpeg") == .video("mpeg"))
    }
}
