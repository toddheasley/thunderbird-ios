//
//  TempEmailModel.swift
//  Thunderbird
//
//  Created by Ashley Soucar on 12/5/25.
//

import Foundation

import SwiftData
@Model
class TempEmail {

    var senderText: String
    var headerText: String
    var bodyText: String
    var dateSent: Date
    var uuid: UUID

    // For alignment, bool check likely not final
    var unread: Bool
    var newEmail: Bool
    var hasAttachment: Bool
    var isThread: Bool

    init(sender: String, headerText: String, bodyText: String, dateSent: Date, unread: Bool, newEmail: Bool, hasAttachment: Bool, isThread: Bool) {
        self.senderText = sender
        self.headerText = headerText
        self.bodyText = bodyText
        self.dateSent = dateSent
        self.unread = unread
        self.newEmail = newEmail
        self.hasAttachment = hasAttachment
        self.isThread = isThread
        self.uuid = UUID()
    }

    @MainActor static let sampleData = [
        TempEmail(
            sender: "Sender1",
            headerText: "Email one",
            bodyText: "This is some nice long text",
            dateSent: Date(),
            unread: true,
            newEmail: true,
            hasAttachment: false,
            isThread: false
        ),
        TempEmail(
            sender: "Sender1",
            headerText: "Email two",
            bodyText: "This is some nice long text",
            dateSent: Date(timeIntervalSinceNow: -6000),
            unread: true,
            newEmail: false,
            hasAttachment: false,
            isThread: false
        ),
        TempEmail(
            sender: "Sender2",
            headerText: "Email three with a longer set of text",
            bodyText: "This is some nice long text",
            dateSent: Date(timeIntervalSinceNow: -6200),
            unread: false,
            newEmail: false,
            hasAttachment: true,
            isThread: true
        ),
        TempEmail(
            sender: "Sender5",
            headerText: "Email four with a longer set of text",
            bodyText: "This is some nice long text",
            dateSent: Date(timeIntervalSinceNow: -16000),
            unread: true,
            newEmail: false,
            hasAttachment: false,
            isThread: true
        ),
        TempEmail(
            sender: "Sender5",
            headerText: "Email four with a longer set of text",
            bodyText: "This is some nice long text",
            dateSent: Date(timeIntervalSinceNow: -57000),
            unread: false,
            newEmail: false,
            hasAttachment: true,
            isThread: false
        )
    ]

}
