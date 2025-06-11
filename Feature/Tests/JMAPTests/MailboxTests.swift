import Testing
@testable import JMAP
import Foundation

struct MailboxTests {
    @Test func getMethod() throws {
        let ids: [String] = [
            "Me542737e24136513aaee4d41",
            "M56e3027f5b7cdfa3c2ce53ff"
        ]
        #expect(Mailbox.GetMethod.name == "Mailbox/get")
        #expect(try Mailbox.GetMethod("u7a5e4041").accountID == "u7a5e4041")
        #expect(try Mailbox.GetMethod("u7a5e4041", ids: ids).ids == ids)
        let dataWithIDs: Data = try JSONSerialization.data(withJSONObject: try Mailbox.GetMethod("u7a5e4041", ids: ids, id: id).object)
        guard let objectWithIDs: [Any] = try JSONSerialization.jsonObject(with: dataWithIDs) as? [Any], objectWithIDs.count == 3 else {
            throw URLError(.cannotDecodeContentData)
        }
        #expect(objectWithIDs[0] as? String == "Mailbox/get")
        #expect((objectWithIDs[1] as? [String: Any])?["accountId"] as? String == "u7a5e4041")
        #expect((objectWithIDs[1] as? [String: Any])?["ids"] as? [String] == ids)
        #expect(objectWithIDs[2] as? String == id.uuidString)
        let dataNoIDs: Data = try JSONSerialization.data(withJSONObject: try Mailbox.GetMethod("u7a5e4041", id: id).object)
        guard let objectNoIDs: [Any] = try JSONSerialization.jsonObject(with: dataNoIDs) as? [Any], objectNoIDs.count == 3 else {
            throw URLError(.cannotDecodeContentData)
        }
        #expect(objectNoIDs[0] as? String == "Mailbox/get")
        #expect((objectNoIDs[1] as? [String: Any])?["accountId"] as? String == "u7a5e4041")
        #expect((objectNoIDs[1] as? [String: Any])?["ids"] as? [String] == nil)
        #expect(objectNoIDs[2] as? String == id.uuidString)
        #expect(throws: MethodError.self) {
            try Mailbox.GetMethod("")
        }
    }
}

// swift-format-ignore
private let id: UUID = UUID(uuidString: "AFF25F76-8105-413F-9CF7-F66B7703B8BD")!
