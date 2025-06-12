import Foundation
import Autodiscover

extension URLSession {

    /// Post methods to JMAP service.
    /// - Parameter methods: One or more ``Method``s for JMAP service to perform
    /// - Parameter url: API endpoint URL from ``Session``
    /// - Parameter token: OAuth bearer token to authenticate with service provider
    /// - Returns: ?
    public func jmapAPI(_ methods: [any Method], url: URL, token: String) async throws -> [MethodResponse] {
        let data: Data = try await data(for: try .jmapAPI(methods, url: url, token: token)).0
        let object: Any = try JSONSerialization.jsonObject(with: data)
        guard let object: [String: Any] = object as? [String: Any],
              let responses: [[Any]] = object["methodResponses"] as? [[Any]], !responses.isEmpty else {
            throw URLError(.cannotDecodeContentData)
        }
        return try responses.map { response in
            guard response.count == 3,
                  let name: String = response[0] as? String, name.contains("/"),
                  let object: [String: Any] = response[1] as? [String: Any],
                  let notFound: [String] = object["notFound"] as? [String],
                  let list: [Any] = object["list"] as? [Any],
                  let id: UUID = UUID(uuidString: response[2] as? String ?? "") else {
                throw URLError(.cannotDecodeContentData)
            }
            let data: Data = try JSONSerialization.data(withJSONObject: list)
            return MethodResponse(name, data: data, notFound: notFound, id: id)
        }
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
