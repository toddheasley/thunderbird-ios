import Foundation

extension URLRequest {
    static func languages(project slug: String, token: String? = nil) -> Self {
        .request(.languages(project: slug), token: token)
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
