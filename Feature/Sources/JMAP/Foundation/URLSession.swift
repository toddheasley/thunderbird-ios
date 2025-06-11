import Foundation
import Autodiscover

extension URLSession {
    
    /// Post methods to JMAP service.
    /// - Parameter methods: One or more ``Method``s for JMAP service to perform
    /// - Parameter url: API endpoint URL from ``Session``
    /// - Parameter token: OAuth bearer token to authenticate with service provider
    /// - Returns: ?
    public func jmapAPI(_ methods: [any Method], url: URL, token: String) async throws -> [any Decodable] {
        let data: Data = try await data(for: try .jmapAPI(methods, url: url, token: token)).0
        throw MethodError.unknownMethod
    }
    
    /// Get JMAP session object from a service provider.
    /// - Parameter host: Host name of the JMAP service provider; e.g., `api.fastmail.com`
    /// - Parameter token: OAuth bearer token to authenticate with service provider
    /// - Returns: ``Session`` object containing available account(s), capabilities and service URLs
    public func jmapSession(_ host: String, port: Int? = nil, token: String) async throws -> Session {
        let data: Data = try await data(for: try .jmapSession(host, port: port, token: token)).0
        let session: Session = try JSONDecoder().decode(Session.self, from: data)
        return session
    }
}
