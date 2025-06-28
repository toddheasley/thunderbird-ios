import Foundation
@testable import JMAP
import Testing

struct FilterTests {
    @Test func conditionObject() {
        #expect(Filter.Condition.inMailbox("M56e3027f5b7cdfa3c2ce53ff").object["inMailbox"] as? String == "M56e3027f5b7cdfa3c2ce53ff")
        #expect(
            Filter.Condition.inMailboxOtherThan([
                "M56e3027f5b7cdfa3c2ce53ff",
                "Me542737e24136513aaee4d41"
            ]).object["inMailboxOtherThan"] as? [String] == [
                "M56e3027f5b7cdfa3c2ce53ff",
                "Me542737e24136513aaee4d41"
            ])
        // #expect(Filter.Condition.before(Date()).object["before"] as? String == "") // TODO: Figure out what ISO date format Fastmail, etc. expects
        #expect(Filter.Condition.maxSize(5_242_880).object["maxSize"] as? Int == 5_242_880)
        #expect(Filter.Condition.allInThreadHaveKeyword("$important").object["allInThreadHaveKeyword"] as? String == "$important")
        #expect(Filter.Condition.hasAttachment(true).object["hasAttachment"] as? Bool == true)
    }

    @Test func conditionDescription() {
        #expect(Filter.Condition.inMailbox("M56e3027f5b7cdfa3c2ce53ff").description == "inMailbox: M56e3027f5b7cdfa3c2ce53ff")
        #expect(
            Filter.Condition.inMailboxOtherThan([
                "M56e3027f5b7cdfa3c2ce53ff",
                "Me542737e24136513aaee4d41"
            ]).description == "inMailboxOtherThan: [\"M56e3027f5b7cdfa3c2ce53ff\", \"Me542737e24136513aaee4d41\"]")
        #expect(Filter.Condition.after(Date(timeIntervalSince1970: 0.0)).description == "after: 1970-01-01 00:00:00 +0000")
        #expect(Filter.Condition.minSize(1024).description == "minSize: 1024")
        #expect(Filter.Condition.noneInThreadHaveKeyword("$important").description == "noneInThreadHaveKeyword: $important")
        #expect(Filter.Condition.hasAttachment(true).description == "hasAttachment: true")
    }
}
