import Testing
@testable import JMAP
import Foundation

struct MethodErrorTests {
    @Test func decoderInit() throws {
        let errors: [MethodError] = try JSONDecoder().decode([MethodError].self, from: data)
        #expect(errors.count == 2)
        #expect(errors.first == .accountNotSupportedByMethod)
        #expect(errors.last == .unknownMethod)
    }
}

private let data: Data = """
[
    [
        "error",
        {
            "type": "accountNotSupportedByMethod"
        },
        ""
    ],
    [
        "error",
        {
            "type": "unknownMethod"
        },
        "call-id"
    ]
]
""".data(using: .utf8)!
