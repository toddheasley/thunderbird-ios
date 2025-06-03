import Testing
@testable import JMAP
import Foundation

@Test func getSession() async throws {
    let token: String = "fmu1-7a5e4041-4c600eb0f9b674aeb9abe842b70f02d1-0-1e911257e86b1f194daaa89faae5c11f"
    let baseURL: URL = URL(string: "https://api.fastmail.com")!
    
    var request: URLRequest = URLRequest(url: URL(string: "/jmap/session", relativeTo: baseURL)!)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    let response: (Data, URLResponse) = try await URLSession.shared.data(for: request)
    
    if let string: String = String(data: response.0, encoding: .utf8) {
        print(string)
    }
}

struct JMAPRequestTests {
    @Test func errorDecoderInit() throws {
        let errors: [JMAPRequest.Error] = try JSONDecoder().decode([JMAPRequest.Error].self, from: errorJSON)
        #expect(errors.count == 2)
        #expect(errors.first?.code == .unknownCapability)
        #expect(errors.first?.description == "The request object used capability which is not supported by this server.")
        #expect(errors.last?.code == .limit)
        #expect(errors.last?.description == "The request is larger than the server is willing to process.")
    }
}

private let errorJSON: Data = """
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
