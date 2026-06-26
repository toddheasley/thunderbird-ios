// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import EmailAddress
import Foundation
import IMAP
import JMAP
import MIME

/// Common `Email` model represents and losslessly converts to and from both ``IMAP.Message`` and ``JMAP.Email``
public struct Email: CustomStringConvertible, Identifiable, Sendable {
    public let from: [EmailAddressProtocol]
    public let sender: [EmailAddressProtocol]
    public let replyTo: [EmailAddressProtocol]
    public let to: [EmailAddressProtocol]
    public let bcc: [EmailAddressProtocol]
    public let cc: [EmailAddressProtocol]
    public let received: Date?  // IMAP internal message date
    public let sent: Date?  // IMAP envelope date
    public let messageID: [String]
    public let threadID: [String]
    public let inReplyTo: [String]
    public let subject: String?
    public let body: Body?

    public init(
        from: [EmailAddressProtocol] = [],
        sender: [EmailAddressProtocol] = [],
        replyTo: [EmailAddressProtocol] = [],
        to: [EmailAddressProtocol] = [],
        bcc: [EmailAddressProtocol] = [],
        cc: [EmailAddressProtocol] = [],
        received: Date? = nil,
        sent: Date? = nil,
        messageID: [String] = [],
        threadID: [String] = [],
        inReplyTo: [String] = [],
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
    public var description: String { messageID.first ?? id }

    // MARK: Identifiable
    public let id: String  // IMAP message ID
}

extension Email {
    // Decode Gmail message ID, if present
    var gmailMessageID: UInt64? {
        guard let id: UInt64 = UInt64(messageID.last ?? ""), id > .gmailIDFloor else {
            return nil
        }
        return id
    }

    // Decode Gmail thread ID, if present
    var gmailThreadID: UInt64? {
        guard let id: UInt64 = UInt64(threadID.last ?? ""), id > .gmailIDFloor else {
            return nil
        }
        return id
    }

    // Map from IMAP message
    init(_ message: IMAP.Message) {
        self.init(
            from: message.envelope.from,
            sender: message.envelope.sender,
            replyTo: message.envelope.reply,
            to: message.envelope.to,
            bcc: message.envelope.bcc,
            cc: message.envelope.cc,
            received: message.internalDate,  // IMAP internal message date
            sent: message.envelope.date?.date,  // IMAP envelope date; forget sender time zone
            messageID: message.messageIDs,
            threadID: message.threadIDs,
            inReplyTo: message.inReplyTo,
            subject: message.envelope.subject,
            body: message.body,
            id: message.emailID ?? message.gmailID
        )
    }

    // Map from JMAP email
    init(_ email: JMAP.Email) {
        self.init(
            from: email.from ?? [],
            sender: email.sender ?? [],
            replyTo: email.replyTo ?? [],
            to: email.to ?? [],
            bcc: email.bcc ?? [],
            cc: email.cc ?? [],
            received: email.receivedAt,
            sent: email.sentAt,
            messageID: email.messageID ?? [],
            threadID: [email.threadID],
            inReplyTo: email.inReplyTo ?? [],
            subject: email.subject,
            body: nil,
            id: email.id
        )
    }
}

extension IMAP.Message {

    // Use `gmailMessageID` as ID string, if present
    var gmailID: String? { gmailMessageID != nil ? "\(gmailMessageID!)" : nil }

    // Collect available message IDs, plain and/or Gmail flavored
    var messageIDs: [String] {
        var ids: [String] = []
        if let id: String = envelope.messageID {
            ids.append(id)
        }
        if let id: UInt64 = gmailMessageID {
            ids.append("\(id)")
        }
        return ids
    }

    // Collect available thread IDs, plain and/or Gmail flavored
    var threadIDs: [String] {
        var ids: [String] = []
        if let id: String = threadID {
            ids.append(id)
        }
        if let id: UInt64 = gmailThreadID {
            ids.append("\(id)")
        }
        return ids
    }

    var inReplyTo: [String] {
        var ids: [String] = []
        if let id: String = envelope.inReplyTo {
            ids.append(id)
        }
        return ids
    }
}

private extension UInt64 {
    static let gmailIDFloor: Self = 1_000_000_000_000
}
