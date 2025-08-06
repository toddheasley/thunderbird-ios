import Foundation

/// Authorization credential  for a given user name, either an OAuth token or basic password
public enum Authorization: CustomStringConvertible, Equatable {
    case basic(user: String, password: String)
    case oauth(user: String, token: String)

    public var user: String {
        switch self {
        case .basic(let user, _), .oauth(let user, _): user
        }
    }

    /// Formatted `URLRequest` Authorization header value
    public var value: String {
        switch self {
        case .basic: "Basic \(password)"
        case .oauth: "Bearer \(password)"
        }
    }

    /// Encoded `URLCredential` password value (for keychain storage)
    var password: String {
        switch self {
        case .basic(let user, let password): "\(user):\(password)".data(using: .utf8)!.base64EncodedString()
        case .oauth(_, let token): token
        }
    }

    /// Derive appropriate authorization case from naked `URLCredential` user/password strings.
    init(user: String, password: String?) {
        let password: String = password ?? ""
        if let data: Data = Data(base64Encoded: password),
            let components: [String] = String(data: data, encoding: .utf8)?.components(separatedBy: ":"),
            components.count == 2, components.first == user
        {
            self = .basic(user: user, password: components.last!)
        } else {
            self = .oauth(user: user, token: password)
        }
    }

    // MARK: CustomStringConvertible
    public var description: String { value }
}
