import Foundation

extension URLSession {
    public func session(_ host: String, token: String) async throws -> Session {
        let data: Data = try await data(for: try .session(host, token: token)).0
        let session: Session = try JSONDecoder().decode(Session.self, from: data)
        return session
    }
}
