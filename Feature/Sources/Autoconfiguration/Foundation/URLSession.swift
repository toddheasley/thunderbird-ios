import Foundation

extension URLSession {
    public func autoconfig(_ emailAddress: EmailAddress, sources: [Source] = Source.allCases) async throws -> ClientConfig {
        for source in sources {
            guard let config: ClientConfig = try? await autoconfig(emailAddress, source: source) else { continue }
            return config
        }
        throw URLError(.fileDoesNotExist)
    }

    public func autoconfig(_ emailAddress: EmailAddress, source: Source) async throws -> ClientConfig {
        let url: URL = try .autoconfig(emailAddress, source: source)
        let data: (Data, URLResponse) = try await data(from: url)
        switch (data.1 as? HTTPURLResponse)?.statusCode {
        case 200:
            let data: Data = try Parser(data.0).data
            let config: ClientConfig = try JSONDecoder().decode(ClientConfig.self, from: data)
            return config
        case 404:
            throw URLError(.fileDoesNotExist)
        default:
            throw URLError(.unsupportedURL)
        }
    }
}
