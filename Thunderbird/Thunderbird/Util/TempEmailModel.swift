//
//  TempEmailModel.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 12/5/25.
//

import Foundation

import SwiftData
import EmailAddress
@Model
class TempEmail {
    var headerText: String
    var bodyText: String
    var dateSent: Date
    var uuid: UUID

    var from: [EmailAddress]
    var sender: [EmailAddress]
    var reply: [EmailAddress]
    var to: [EmailAddress]
    var cc: [EmailAddress]
    var bcc: [EmailAddress]
    var attachments: [Data]!

    // For alignment, bool check likely not final
    var unread: Bool
    var newEmail: Bool
    var isThread: Bool
    var pinned: Bool

    init(
        from: [EmailAddress],
        sender: [EmailAddress],
        reply: [EmailAddress],
        to: [EmailAddress],
        cc: [EmailAddress],
        bcc: [EmailAddress],
        headerText: String,
        bodyText: String,
        dateSent: Date,
        unread: Bool,
        newEmail: Bool,
        attachments: [Data]!,
        isThread: Bool,
        pinned: Bool
    ) {
        self.from = from
        self.sender = sender
        self.reply = reply
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.headerText = headerText
        self.bodyText = bodyText
        self.dateSent = dateSent
        self.unread = unread
        self.newEmail = newEmail
        self.attachments = attachments
        self.isThread = isThread
        self.uuid = UUID()
        self.pinned = pinned
    }

    @MainActor static let sampleData = [
        TempEmail(
            from: [EmailAddress("sender1@test.com", label: "Sender1")],
            sender: [EmailAddress("sender1@test.com", label: "Sender1")],
            reply: [EmailAddress("sender1@test.com", label: "Sender1")],
            to: [EmailAddress("rheaThun@thundermail.com", label: "Rhea Thunderbird")],
            cc: [],
            bcc: [],
            headerText: "Email one",
            bodyText: "This is some nice long text",
            dateSent: Date(),
            unread: true,
            newEmail: true,
            attachments: nil,
            isThread: false,
            pinned: false
        ),
        TempEmail(
            from: [EmailAddress("sender1@test.com", label: "Sender1")],
            sender: [EmailAddress("sender1@test.com", label: "Sender1")],
            reply: [EmailAddress("sender1@test.com", label: "Sender1")],
            to: [EmailAddress("rheaThun@thundermail.com", label: "Rhea Thunderbird")],
            cc: [],
            bcc: [],
            headerText: "Email two",
            bodyText: "This is some nice long text",
            dateSent: Date(timeIntervalSinceNow: -6000),
            unread: true,
            newEmail: false,
            attachments: nil,
            isThread: false,
            pinned: true
        ),
        TempEmail(
            from: [EmailAddress("sendera@test.com", label: "Sendera")],
            sender: [],
            reply: [EmailAddress("sender2replyto@test.com", label: "Sender2")],
            to: [EmailAddress("rheaThun@thundermail.com", label: "Rhea Thunderbird")],
            cc: [],
            bcc: [],
            headerText: "Email three with a longer set of text",
            bodyText: "This is some nice long text",
            dateSent: Date(timeIntervalSinceNow: -6200),
            unread: false,
            newEmail: false,
            attachments: nil,
            isThread: true,
            pinned: false
        ),
        TempEmail(
            from: [EmailAddress("sender3@test.com", label: "Sender3")],
            sender: [EmailAddress("sender3@test.com", label: "Sender3")],
            reply: [EmailAddress("sender2@test.com", label: "Sender2")],
            to: [EmailAddress("rheaThun@thundermail.com", label: "Rhea Thunderbird")],
            cc: [EmailAddress("rocThun@thundermail.com", label: "Roc Thunderbird"), EmailAddress("rocjrThun@thundermail.com"), EmailAddress("rocsrThun@thundermail.com", label: "Dad")],
            bcc: [],
            headerText: "Email four with a longer set of text",
            bodyText: "This is some nice long text",
            dateSent: Date(timeIntervalSinceNow: -100000),
            unread: true,
            newEmail: false,
            attachments: nil,
            isThread: true,
            pinned: false
        ),
        TempEmail(
            from: [EmailAddress("sender2@test.com", label: "Sender2")],
            sender: [EmailAddress("sender2@test.com", label: "Sender2")],
            reply: [EmailAddress("sender2@test.com", label: "Sender2")],
            to: [EmailAddress("rheaThun@thundermail.com", label: "Rhea Thunderbird")],
            cc: [],
            bcc: [],
            headerText: "Email four with a longer set of text",
            bodyText: "This is some nice long text",
            dateSent: Date(timeIntervalSinceNow: -257000),
            unread: false,
            newEmail: false,
            attachments: [Data()],
            isThread: false,
            pinned: false
        )
    ]

}
