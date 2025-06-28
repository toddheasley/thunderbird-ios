import Foundation
@testable import JMAP
import Testing

struct JSONDecoderTests {
    @Test func dateDecodingStrategy() throws {
        let dates: [Date] = try JSONDecoder(date: .iso8601).decode([Date].self, from: data)
        try #require(dates.count == 3)
        #expect(dates[0].description == "2025-06-27 20:52:45 +0000")
        #expect(dates[1].description == "2025-06-28 15:13:45 +0000")
        #expect(dates[2].description == "2025-06-28 15:13:45 +0000")
    }
}

private let data: Data = """
    [
        "2025-06-27T16:52:45-04:00",
        "2025-06-28T11:13:45-04:00",
        "2025-06-28T15:13:45Z"
    ]
    """.data(using: .utf8)!
