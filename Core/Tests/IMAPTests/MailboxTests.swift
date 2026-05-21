// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

@testable import IMAP
import Testing

struct MailboxNameTests {
    @Test func stringInit() {
        #expect(Mailbox.Name("Inbox") == .inbox)
        #expect(Mailbox.Name("").debugDescription == "")
    }

    // MARK: CustomStringConvertible
    @Test func description() {
        #expect(Mailbox.Name.inbox.description == "INBOX")
        #expect(Mailbox.Name("Deleted Items").description == "Deleted Items")
        #expect(Mailbox.Name("Sent").description == "Sent")
    }
}
