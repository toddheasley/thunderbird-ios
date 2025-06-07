import Testing
@testable import Autodiscovery
import Foundation

struct SRVTests {
    @Test func query() async throws {
        let records: [SRV.Record] = try await SRV(timeoutInterval: 1.5).query("_jmap._tcp.fastmail.com")
        #expect(records.first?.description == "0 1 443 api.fastmail.com")
    }
}
