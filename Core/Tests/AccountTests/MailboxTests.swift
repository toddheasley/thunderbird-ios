@testable import Account
import Testing
import Foundation

struct MailboxPathTests {
    @Test func role() throws {
        #expect(try IMAP.Mailbox.Path(name: "INBOX").role == .inbox)
        #expect(try IMAP.Mailbox.Path(name: "[Gmail]/Inbox", pathSeparator: "/").role == .inbox)
        #expect(try IMAP.Mailbox.Path(name: "Sent Mail").role == .sent)
        #expect(try IMAP.Mailbox.Path(name: "Deleted Items").role == nil)
        #expect(try IMAP.Mailbox.Path(name: "junk mail").role == .junk)
        #expect(try IMAP.Mailbox.Path(name: "Spam").role == nil)
        #expect(try IMAP.Mailbox.Path(name: "Trash").role == .trash)
    }
}
