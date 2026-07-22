// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
@testable import MIME
import Testing

struct BodyTests {
    @Test func headers() throws {
        #expect(
            try Body(.aol).headers == [
                try! Header(.contentType, "multipart/alternative; boundary=\"-=Part.d96da9.c8ced2f941b41333.19beaf8523d.267666a9a62272b=-\""),
                .mimeVersion
            ])
        #expect(
            try Body(.fastmail).headers == [
                try! Header(.contentTransferEncoding, "8bit"),
                try! Header(.contentType, "multipart/alternative; boundary=\"_----------=_17617196041979919223967\""),
                .mimeVersion
            ])
        #expect(
            try Body(.icloud).headers == [
                try! Header(.contentType, "multipart/alternative; boundary=\"----=_Part_15950895_843396275.1764942606546\""),
                .mimeVersion
            ])
        #expect(
            try Body(.outlook).headers == [
                try! Header(.contentType, "multipart/alternative; boundary=\"b1_dd99cd789bcc10ebb82bcc39304a9664\""),
                .mimeVersion
            ])
        #expect(
            try Body(.posteo).headers == [
                try! Header(.contentType, "multipart/alternative; boundary=\"MULTIPART-MIXED-BOUNDARY\""),
                .mimeVersion
            ])
    }

    @Test func descriptionInit() throws {
        let aol: Body = try Body(.aol)
        #expect(aol.contentType == .multipart(.alternative, try! Boundary("-=Part.d96da9.c8ced2f941b41333.19beaf8523d.267666a9a62272b=-")))
        #expect(aol.contentTransferEncoding == nil)
        #expect(try aol.part.parts.first?.contentType == .text(.html, .utf8))
        #expect(try aol.part.parts.count == 1)
        let fastmail: Body = try Body(.fastmail)
        #expect(fastmail.contentType == .multipart(.alternative, try! Boundary("_----------=_17617196041979919223967")))
        #expect(fastmail.contentTransferEncoding == .data)
        #expect(try fastmail.part.parts.first?.contentType == .text(.plain, .utf8))
        #expect(try fastmail.part.parts.count == 2)
        let icloud: Body = try Body(.icloud)
        #expect(icloud.contentType == .multipart(.alternative, try! Boundary("----=_Part_15950895_843396275.1764942606546")))
        #expect(icloud.contentTransferEncoding == nil)
        #expect(try icloud.part.parts.first?.contentType == .text(.html, .iso8859))
        #expect(try icloud.part.parts.count == 1)
        let outlook: Body = try Body(.outlook)
        #expect(outlook.contentType == .multipart(.alternative, try! Boundary("b1_dd99cd789bcc10ebb82bcc39304a9664")))
        #expect(outlook.contentTransferEncoding == nil)
        #expect(try outlook.part.parts.first?.contentType == .text(.plain, .utf8))
        #expect(try outlook.part.parts.count == 2)
        let posteo: Body = try Body(.posteo)
        #expect(posteo.contentType == .multipart(.alternative, try! Boundary("MULTIPART-MIXED-BOUNDARY")))
        #expect(posteo.contentTransferEncoding == nil)
        #expect(try posteo.part.parts.first?.contentType == .text(.html, .utf8))
        #expect(try posteo.part.parts.count == 2)
    }

    // MARK: RawRepresentable
    @Test func rawValue() throws {
        print(String(data: try Body(.fastmail).rawValue, encoding: .ascii) ?? "nil")
        #expect(try Body(.aol).rawValue.count == 4822)
        #expect(try Body(.fastmail).rawValue.count == 20589)
        #expect(try Body(.icloud).rawValue.count == 8795)
        #expect(try Body(.outlook).rawValue.count == 69543)
        #expect(try Body(.posteo).rawValue.count == 89986)
    }
}

extension BodyTests {
    @Test func empty() throws {
        #expect(try Body.empty.part.data == "".data(using: .ascii)!)
        #expect(try Body.empty.part.contentType == .text(.plain, .ascii))
        #expect(Body.empty.contentType == .text(.plain, .ascii))
    }

    @Test func isEmpty() throws {
        #expect(try Body(.aol).isEmpty == false)
        #expect(try Body(.fastmail).isEmpty == false)
        #expect(try Body(.icloud).isEmpty == false)
        #expect(try Body(.outlook).isEmpty == false)
        #expect(try Body(.posteo).isEmpty == false)
        #expect(Body.empty.isEmpty == true)
    }
}

private extension Data {
    static var aol: Self { try! Bundle.module.data(forResource: "mime-body-aol.eml") }
    static var fastmail: Self { try! Bundle.module.data(forResource: "mime-body-fastmail.eml") }
    static var icloud: Self { try! Bundle.module.data(forResource: "mime-body-icloud.eml") }
    static var outlook: Self { try! Bundle.module.data(forResource: "mime-body-outlook.eml") }
    static var posteo: Self { try! Bundle.module.data(forResource: "mime-body-posteo.eml") }
}
