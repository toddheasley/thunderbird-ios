import Foundation

extension URLRequest {
    static func languages(project name: String, token: String? = nil) throws -> Self {
        .request(try .languages(project: name), token: token)
    }

    static func request(_ url: URL, token: String? = nil) -> Self {
        var request: Self = Self(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token, !token.isEmpty {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
