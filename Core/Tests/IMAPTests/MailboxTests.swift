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
