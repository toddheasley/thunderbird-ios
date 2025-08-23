import Foundation

extension URLSession {

    /// Query multiple autoconfig sources for a given email address.
    public func autoconfig(_ emailAddress: EmailAddress, sources: [Source] = Source.allCases) async throws -> (config: ClientConfig, source: Source) {
        for source in sources {
            guard let config: ClientConfig = try? await autoconfig(emailAddress, source: source).config else { continue }
            return (config, source)
        }
        throw URLError(.fileDoesNotExist)
    }

    // Query a single autoconfig source for a given email address.
    public func autoconfig(_ emailAddress: EmailAddress, source: Source) async throws -> (config: ClientConfig, data: (Data, Data)) {
        let url: URL = try .autoconfig(emailAddress, source: source)
        let data: (Data, URLResponse) = try await data(from: url)
        switch (data.1 as? HTTPURLResponse)?.statusCode {
        case 200:
            let json: Data = try Parser(emailAddress, data: data.0).data
            let container: Container = try JSONDecoder().decode(Container.self, from: json)
            return (container.clientConfig, (json, data.0))
        case 404:
            throw URLError(.fileDoesNotExist)
        default:
            throw URLError(.unsupportedURL)
        }
    }
}

private struct Container: Decodable {
    let clientConfig: ClientConfig
}
