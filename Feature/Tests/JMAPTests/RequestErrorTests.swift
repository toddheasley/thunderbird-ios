import Testing
@testable import JMAP
import Foundation

struct RequestErrorTests {
    @Test func decoderInit() throws {
        let errors: [RequestError] = try JSONDecoder().decode([RequestError].self, from: data)
        #expect(errors.count == 2)
        #expect(errors.first?.code == .unknownCapability)
        #expect(errors.first?.description == "The request object used capability which is not supported by this server.")
        #expect(errors.last?.code == .limit)
        #expect(errors.last?.description == "The request is larger than the server is willing to process.")
    }
}

// swift-format-ignore
private let data: Data = """
[
    {
        "type": "urn:ietf:params:jmap:error:unknownCapability",
        "status": 400,
        "detail": "The request object used capability which is not supported by this server."
    },
    {
        "type": "urn:ietf:params:jmap:error:limit",
        "limit": "maxSizeRequest",
        "status": 400,
        "detail": "The request is larger than the server is willing to process."
    }
]
""".data(using: .utf8)!
