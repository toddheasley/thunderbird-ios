import Foundation
@testable import IMAP
import Testing

struct MessageTests {

}

extension MessageTests {
    struct FlagTests {

        // MARK: CustomStringConvertible
        @Test func description() {
            #expect(Message.Flag.answered.description == "\\Answered")
            #expect(Message.Flag.deleted.description == "\\Deleted")
            #expect(Message.Flag.draft.description == "\\Draft")
            #expect(Message.Flag.flagged.description == "\\Flagged")
            #expect(Message.Flag.seen.description == "\\Seen")
            #expect(Message.Flag.extension("\\Example").description == "\\Example")
            #expect(Message.Flag.keyword(.junk).description == "$Junk")
        }
    }
}
