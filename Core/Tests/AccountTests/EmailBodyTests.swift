// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

@testable import Account
import Testing
import Foundation

struct EmailBodyTests {}

extension EmailBodyTests {
    @Test(arguments: uuids) func bodyInit(_ uuid: String) throws {
        let body: EmailBody = try EmailBody(body: try Body(.mock(uuid)))
        switch uuid {
        case "2EA571DD":
            #expect(body.attachments.isEmpty == true)
            #expect(body.html?.count == 4239)
            #expect(body.text == nil)
        case "976C6A94":
            #expect(body.attachments.isEmpty == true)
            #expect(body.html?.count == 27271)
            #expect(body.text?.count == 1842)
        case "86925F24":
            #expect(body.attachments.isEmpty == true)
            #expect(body.html?.count == 3243)
            #expect(body.text?.count == 2172)
        case "7A690F43":
            #expect(body.attachments.isEmpty == true)
            #expect(body.html == nil)
            #expect(body.text?.count == 1591)
        case "60EB5CAE":
            #expect(body.attachments.isEmpty == true)
            #expect(body.html == nil)
            #expect(body.text?.count == 2387)
        case "F02140B7":
            #expect(body.attachments.count == 1)
            #expect(body.html?.count == 2741)
            #expect(body.text == nil)
        case "BFA06D93":
            #expect(body.attachments.isEmpty == true)
            #expect(body.html?.count == 65621)
            #expect(body.text?.count == 599)
        case "89526045":
            #expect(body.attachments.isEmpty == true)
            #expect(body.html?.count == 8072)
            #expect(body.text == nil)
        case "E18BEE81":
            #expect(body.attachments.isEmpty == true)
            #expect(body.html?.count == 18084)
            #expect(body.text?.count == 962)
        case "2874E3C9":
            #expect(body.attachments.count == 1)
            #expect(body.html?.count == 34165)
            #expect(body.text == nil)
        case "1759430F":
            #expect(body.attachments.isEmpty == true)
            #expect(body.html?.count == 15687)
            #expect(body.text?.count == 2916)
        case "E1FA0690":
            #expect(body.attachments.isEmpty == true)
            #expect(body.html?.count == 126076)
            #expect(body.text?.count == 15450)
        case "CFD4D3A3":
            #expect(body.attachments.count == 5)
            #expect(body.html?.count == 5644)
            #expect(body.text?.count == 1492)
        default:
            throw URLError(.fileDoesNotExist)
        }
    }
}

/*
let body: Body = try Body(.mock(uuid))
switch uuid {
case "2EA571DD":
    #expect(body.contentType == .multipart(.alternative, try! Boundary("-=Part.d96da9.c8ced2f941b41333.19beaf8523d.267666a9a62272b=-")))
    #expect(body.contentTransferEncoding == nil)
    #expect(try body.part.parts.first?.contentType == .text(.html, .utf8))
    #expect(try body.part.parts.count == 1)
case "1759430F":
    #expect(body.contentType == .multipart(.alternative, try! Boundary("_----------=_17617196041979919223967")))
    #expect(body.contentTransferEncoding == .data)
    #expect(try body.part.parts.first?.contentType == .text(.plain, .utf8))
    #expect(try body.part.parts.count == 2)
case "89526045":
    #expect(body.contentType == .multipart(.alternative, try! Boundary("----=_Part_15950895_843396275.1764942606546")))
    #expect(body.contentTransferEncoding == nil)
    #expect(try body.part.parts.first?.contentType == .text(.html, .iso8859))
    #expect(try body.part.parts.count == 1)
case "BFA06D93":
    #expect(body.contentType == .multipart(.alternative, try! Boundary("b1_dd99cd789bcc10ebb82bcc39304a9664")))
    #expect(body.contentTransferEncoding == nil)
    #expect(try body.part.parts.first?.contentType == .text(.plain, .utf8))
    #expect(try body.part.parts.count == 2)
case "F02140B7":
    #expect(body.contentType == .multipart(.alternative, try! Boundary("MULTIPART-MIXED-BOUNDARY")))
    #expect(body.contentTransferEncoding == nil)
    #expect(try body.part.parts.first?.contentType == .text(.html, .utf8))
    #expect(try body.part.parts.count == 2)
default:
    break
} */

private extension Data {
    static func mock(_ uuid: String) throws -> Self {
        try Bundle.module.data(forResource: "mime-body-\(uuid).eml")
    }
}

// Short UUID strings correspond to `mime-body`-prefixed `.eml` file in test `Resources`
private let uuids: [String] = [
    "2EA571DD",
    "976C6A94",
    "86925F24",
    "7A690F43",
    "60EB5CAE",
    "F02140B7",
    "BFA06D93",
    "89526045",
    "E18BEE81",
    "2874E3C9",
    "1759430F",
    "E1FA0690",
    "CFD4D3A3"
]
