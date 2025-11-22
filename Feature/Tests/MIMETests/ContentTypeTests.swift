@testable import MIME
import Testing

struct ContentTypeTests {
    @Test func subType() {
        #expect(ContentType.application("zip").subType == "zip")
        #expect(ContentType.image("png").subType == "png")
        #expect(ContentType.multipart("mixed").subType == "mixed")
        #expect(ContentType.text("html").subType == "html")
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
        #expect(ContentType.multipart("mixed").rawValue == "multipart/mixed")
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
        #expect(ContentType(rawValue: "multipart/mixed") == .multipart("mixed"))
        #expect(ContentType(rawValue: "text/html") == .text("html"))
        #expect(ContentType(rawValue: "video/mpeg") == .video("mpeg"))
    }
}

extension ContentTypeTests {
    @Test func multipartAlternative() {
        #expect(ContentType.multipartAlternative.rawValue == "multipart/alternative")
    }

    @Test func multipartMixed() {
        #expect(ContentType.multipartMixed.rawValue == "multipart/mixed")
    }

    @Test func multipartRelated() {
        #expect(ContentType.multipartRelated.rawValue == "multipart/related")
    }
}
