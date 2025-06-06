import Foundation

extension URL {
    static func session(_ host: String) throws -> Self {
        try jmap(host, path: "jmap/session")
    }
    
    static func jmap(_ host: String, path: String? = nil) throws -> Self {
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        guard !host.isEmpty else {
            throw URLError(.cannotFindHost)
        }
        components.host = host
        if let path, !path.isEmpty {
            components.path = path.hasPrefix("/") ? path : "/\(path)"
        }
        guard let url: Self = components.url else {
            throw URLError(.unsupportedURL)
        }
        return url
    }
}
