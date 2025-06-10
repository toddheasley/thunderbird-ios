import Foundation
import Autodiscover

extension URLSession {

    /// Get JMAP session object from a service provider.
    /// - Parameter host: Host name of the JMAP service provider; e.g., `api.fastmail.com`
    /// - Parameter token: OAuth bearer token to authenticate with service provider
    /// - Returns: ``Session`` object containing available account(s), capabilities and service URLs
    public func session(_ host: String, port: Int? = nil, token: String) async throws -> Session {
        let data: Data = try await data(for: try .session(host, port: port, token: token)).0
        let session: Session = try JSONDecoder().decode(Session.self, from: data)
        return session
    }
}
