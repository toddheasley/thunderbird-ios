import Foundation
@testable import MIME
import Testing

struct ContentDispositionTests {
    struct FileTests {
        @Test func filenameInit() {
            #expect(ContentDisposition.File(filename: "filename.jpeg.zip").filename == "filename.jpeg.zip")
            #expect(ContentDisposition.File(filename: "filename.jpeg.zip").filename == "filename.jpeg.zip")
            #expect(ContentDisposition.File(filename: "unic🌐de-file-name.mp3").filename == nil)
            #expect(ContentDisposition.File(filename: "").filename == nil)
            #expect(ContentDisposition.File().filename == nil)
            #expect(ContentDisposition.File(size: 2048).size == 2048)
            #expect(ContentDisposition.File(size: 0).size == nil)
            #expect(ContentDisposition.File().size == nil)
        }

        @Test func parameters() {
            #expect(
                ContentDisposition.File(
                    filename: "filename.jpeg",
                    creationDate: Date(timeIntervalSince1970: 0.0),
                    modificationDate: Date(timeIntervalSince1970: 247158840.0),
                    readDate: Date(timeIntervalSince1970: 1763912400.0),
                    size: 4096
                ).parameters == [
                    "filename=\"filename.jpeg\"",
                    "creation-date=\"01 01 70; 12:00:00 GMT\"",
                    "modification-date=\"31 10 77; 03:14:00 GMT\"",
                    "read-date=\"23 11 25; 03:40:00 GMT\"",
                    "size=4096"
                ])
        }
    }

    @Test func parameters() {
        let file: ContentDisposition.File = ContentDisposition.File(
            filename: "filename.pdf",
            modificationDate: Date(timeIntervalSince1970: 1763912400.0),
            size: 1024
        )
        #expect(
            ContentDisposition.attachment(file).parameters == [
                "attachment",
                "filename=\"filename.pdf\"",
                "modification-date=\"23 11 25; 03:40:00 GMT\"",
                "size=1024"
            ])
        #expect(
            ContentDisposition.inline(file).parameters == [
                "inline",
                "filename=\"filename.pdf\"",
                "modification-date=\"23 11 25; 03:40:00 GMT\"",
                "size=1024"
            ])
    }

    @Test func value() {
        #expect(ContentDisposition.attachment.value == "attachment")
        #expect(ContentDisposition.inline.value == "inline")
        #expect(ContentDisposition.extensionToken.value == "extension-token")
    }
}
