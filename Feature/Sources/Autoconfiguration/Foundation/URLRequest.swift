import Foundation

extension URLRequest {
    public static func token(_ request: OAuth2.Request, code: String) throws -> Self {
        guard
            var components: URLComponents = URLComponents(
                url: request.tokenURL(code),
                resolvingAgainstBaseURL: false
            ), let httpBody: Data = components.percentEncodedQuery?.data(using: .utf8)
        else {
            throw URLError(.badURL)
        }
        components.queryItems = nil
        var request: Self = Self(url: components.url!)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        return request
    }
}
