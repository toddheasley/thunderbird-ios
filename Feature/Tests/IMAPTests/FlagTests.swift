@testable import IMAP
import Testing

struct FlagTests {

    // MARK: CustomStringConvertible
    @Test func description() {
        #expect(Flag.answered.description == "\\Answered")
        #expect(Flag.deleted.description == "\\Deleted")
        #expect(Flag.draft.description == "\\Draft")
        #expect(Flag.flagged.description == "\\Flagged")
        #expect(Flag.seen.description == "\\Seen")
    }
}
