// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import EmailAddress
import Foundation
import IMAP
import JMAP
import MIME

public struct Email: CustomStringConvertible, Identifiable, Sendable {
    public let from: [EmailAddressProtocol]?
    public let sender: [EmailAddressProtocol]?
    public let replyTo: [EmailAddressProtocol]?
    public let to: [EmailAddressProtocol]?
    public let bcc: [EmailAddressProtocol]?
    public let cc: [EmailAddressProtocol]?
    public let received: Date?  // IMAP internal message date
    public let sent: Date?  // IMAP envelope date
    public let messageID: [String]?
    public let threadID: [String]?
    public let inReplyTo: [String]?
    public let subject: String?
    public let body: Body?

    public init(
        from: [EmailAddressProtocol]? = nil,
        sender: [EmailAddressProtocol]? = nil,
        replyTo: [EmailAddressProtocol]? = nil,
        to: [EmailAddressProtocol]? = nil,
        bcc: [EmailAddressProtocol]? = nil,
        cc: [EmailAddressProtocol]? = nil,
        received: Date? = nil,
        sent: Date? = nil,
        messageID: [String]? = nil,
        threadID: [String]? = nil,
        inReplyTo: [String]? = nil,
        subject: String? = nil,
        body: Body? = nil,
        id: String? = nil
    ) {
        self.from = from
        self.sender = sender
        self.replyTo = replyTo
        self.to = to
        self.bcc = bcc
        self.cc = cc
        self.received = received
        self.sent = sent
        self.messageID = messageID
        self.threadID = threadID
        self.inReplyTo = inReplyTo
        self.subject = subject
        self.body = body
        self.id = id ?? UUID().uuidString(1)
    }

    // MARK: CustomStringConvertible
    public var description: String { "" }

    // MARK: Identifiable
    public let id: String  // Use either IMAP UID or JMAP ID
}

extension Email {
    init(_ message: IMAP.Message) {
        self.init(
            from: message.envelope.from,
            sender: message.envelope.sender,
            replyTo: message.envelope.reply,
            to: message.envelope.to,
            bcc: message.envelope.bcc,
            cc: message.envelope.cc,
            received: message.internalDate,
            sent: message.envelope.date?.date,
            messageID: nil,
            threadID: nil,
            inReplyTo: nil,
            subject: message.envelope.subject,
            body: message.body,
            id: message.emailID
        )
    }

    init(_ email: JMAP.Email) {
        self.init(
            from: email.from,
            sender: email.sender,
            replyTo: email.replyTo,
            to: email.to,
            bcc: email.bcc,
            cc: email.cc,
            received: email.receivedAt,
            sent: email.sentAt,
            messageID: email.messageID,
            threadID: [email.threadID],
            inReplyTo: email.inReplyTo,
            subject: email.subject,
            body: nil,
            id: email.id
        )
    }
}
