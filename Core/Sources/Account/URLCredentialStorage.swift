import Foundation

extension URLCredentialStorage {
    func authorization(for user: String, space: URLProtectionSpace = .account) -> Authorization? {
        credentials(for: space)?[user]?.authorization
    }

    func set(authorization: Authorization, persistence: URLCredential.Persistence = .permanent, space: URLProtectionSpace = .account) {
        if !authorization.password.isEmpty {
            set(URLCredential(authorization: authorization, persistence: persistence), for: space)
        } else if let credential: URLCredential = credentials(for: space)?[authorization.user] {
            remove(credential, for: space)  // Remove existing credential on empty password
        }
    }

    func deleteAuthorizations(space: URLProtectionSpace = .account) {
        for credential in (credentials(for: space) ?? [:]).values {
            remove(credential, for: space)
        }
    }
}
