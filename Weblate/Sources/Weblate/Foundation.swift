import Foundation


extension URLSession {
    public func languages(project slug: String, token: String? = nil) async throws -> [Language] {
        let data: Data = try await data(for: .languages(project: slug, token: token)).0
        return try JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase).decode([Language].self, from: data)
    }
}

extension URLRequest {
    public static func translations(_ component: String, project slug: String, token: String? = nil) -> Self {
        .request(.translations(component, project: slug), token: token)
    }
    
    public static func languages(project slug: String, token: String? = nil) -> Self {
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

extension URL {
    static func translations(_ component: String, project slug: String) -> Self {
        Self(string: "https://hosted.weblate.org/api/components/\(slug)/\(component)/translations/")!
    }
    
    static func languages(project slug: String) -> Self {
        Self(string: "https://hosted.weblate.org/api/projects/\(slug)/languages/")!
    }
}

extension JSONDecoder {
    convenience init(keyDecodingStrategy: KeyDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = keyDecodingStrategy
    }
}
