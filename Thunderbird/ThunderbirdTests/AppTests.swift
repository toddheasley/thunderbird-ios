import Foundation
import Testing

struct ThunderbirdTests {

    @Test func example() async throws {
        #expect(Bundle.main.bundleIdentifier == "net.thunderbird.ios")
    }

}
