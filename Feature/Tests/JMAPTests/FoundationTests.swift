import Testing
@testable import JMAP
import Foundation

struct JSONDecoderTests {
    @Test func jmap() {
        #expect((JSONDecoder.jmap(id: "u7a51e404").userInfo[.id] as? String) == "u7a51e404")
        #expect(JSONDecoder.jmap(id: "").userInfo[.id] == nil)
        #expect(JSONDecoder.jmap(id: nil).userInfo[.id] == nil)
        #expect(JSONDecoder.jmap().userInfo[.id] == nil)
    }
}
