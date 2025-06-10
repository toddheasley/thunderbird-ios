import Foundation

extension URL {
    static func session(_ host: String, port: Int? = nil) throws -> Self {
        try jmap(host, port: port, path: "jmap/session")
    }

    static func jmap(_ host: String, port: Int? = nil, path: String? = nil) throws -> Self {
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        let comp: [String] = host.components(separatedBy: ":")
        guard !host.isEmpty else {
            throw URLError(.cannotFindHost)
        }
        components.host = host
        components.port = port
        if let path, !path.isEmpty {
            components.path = path.hasPrefix("/") ? path : "/\(path)"
        }
        guard let url: Self = components.url else {
            throw URLError(.unsupportedURL)
        }
        return url
    }
}
