import Foundation
@testable import MIME
import Testing

struct BodyTests {
    @Test func headers() throws {
        #expect(
            try Body(.fastmail).headers == [
                "MIME-Version": "1.0",
                "Content-Transfer-Encoding": "8bit",
                "Content-Type": "multipart/alternative; boundary=\"_----------=_17617196041979919223967\""
            ])
        #expect(
            try Body(.icloud).headers == [
                "MIME-Version": "1.0",
                "Content-Type": "multipart/alternative; boundary=\"----=_Part_15950895_843396275.1764942606546\""
            ])
        #expect(
            try Body(.outlook).headers == [
                "MIME-Version": "1.0",
                "Content-Type": "multipart/alternative; boundary=\"b1_dd99cd789bcc10ebb82bcc39304a9664\""
            ])
    }

    @Test func descriptionInit() throws {
        let fastmail: Body = try Body(.fastmail)
        #expect(fastmail.contentType == .multipart(.alternative, try! Boundary("_----------=_17617196041979919223967")))
        #expect(fastmail.contentTransferEncoding == .data)
        #expect(fastmail.parts.first?.contentType == .text(.plain, .utf8))
        #expect(fastmail.parts.count == 2)
        let icloud: Body = try Body(.icloud)
        #expect(icloud.contentType == .multipart(.alternative, try! Boundary("----=_Part_15950895_843396275.1764942606546")))
        #expect(icloud.contentTransferEncoding == nil)
        #expect(icloud.parts.first?.contentType == .text(.html, .iso8859))
        #expect(icloud.parts.count == 1)
        let outlook: Body = try Body(.outlook)
        #expect(outlook.contentType == .multipart(.alternative, try! Boundary("b1_dd99cd789bcc10ebb82bcc39304a9664")))
        #expect(outlook.contentTransferEncoding == nil)
        #expect(outlook.parts.first?.contentType == .text(.plain, .utf8))
        #expect(outlook.parts.count == 2)
    }

    // MARK: RawRepresentable
    @Test func rawValue() throws {
        #expect(try Body(.fastmail).rawValue.count == 21119)
        #expect(try Body(.icloud).rawValue.count == 9025)
        #expect(try Body(.outlook).rawValue.count == 70957)
    }
}

private extension Data {
    static var fastmail: Self { try! Bundle.module.data(forResource: "mime-body-fastmail.eml") }
    static var icloud: Self { try! Bundle.module.data(forResource: "mime-body-icloud.eml") }
    static var outlook: Self { try! Bundle.module.data(forResource: "mime-body-outlook.eml") }
}
