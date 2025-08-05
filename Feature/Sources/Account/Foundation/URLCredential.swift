import Foundation

extension URLCredential {
    var authorization: Authorization? {
        guard let user, let password else { return nil }
        return Authorization(user: user, password: password)
    }

    convenience init(authorization: Authorization, persistence: Persistence = .permanent) {
        self.init(user: authorization.user, password: authorization.password, persistence: persistence)
    }
}
