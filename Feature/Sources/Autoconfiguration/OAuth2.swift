import Foundation

public struct OAuth2: Decodable {
    public struct Request {
        public let authURL: URL
        public let tokenURL: URL
        public let redirectURI: String
        public let scope: [String]
        public let hosts: [String]
        public let clientID: String

        public func matches(_ host: String) -> Bool {
            for _host in hosts {
                guard host.hasSuffix(_host) else { continue }
                return true
            }
            return false
        }

        public init(authURI: String, tokenURI: String, redirectURI: String, scope: [String], clientID: String, hosts: [String] = []) throws {
            guard let authURL: URL = URL(string: authURI),
                let tokenURL: URL = URL(string: tokenURI)
            else {
                throw URLError(.badURL)
            }
            try self.init(
                authURL: authURL,
                tokenURL: tokenURL,
                redirectURI: redirectURI,
                scope: scope,
                clientID: clientID,
                hosts: hosts
            )
        }

        public init(authURL: URL, tokenURL: URL, redirectURI: String, scope: [String], clientID: String, hosts: [String] = []) throws {
            guard !redirectURI.isEmpty,
                !scope.isEmpty, !(scope.first ?? "").isEmpty,
                !clientID.isEmpty
            else {
                throw URLError(.resourceUnavailable)
            }
            self.authURL = authURL
            self.tokenURL = tokenURL
            self.redirectURI = redirectURI
            self.scope = scope
            self.hosts = hosts
            self.clientID = clientID
        }

        public init(_ oauth2: OAuth2, redirectURI: String, clientID: String) throws {
            try self.init(
                authURL: oauth2.authURL,
                tokenURL: oauth2.tokenURL,
                redirectURI: redirectURI,
                scope: oauth2.scope,
                clientID: clientID
            )
        }
    }

    public let authURL: URL
    public let tokenURL: URL
    public let scope: [String]
    public let issuer: String

    // MARK: Decodable
    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: Key.self)
        self.tokenURL = try container.decode(URL.self, forKey: .tokenURL)
        self.authURL = try container.decode(URL.self, forKey: .authURL)
        self.issuer = try container.decode(String.self, forKey: .issuer)
        self.scope = try container.decode(String.self, forKey: .scope).components(separatedBy: " ")
    }

    private enum Key: CodingKey {
        case authURL, issuer, scope, tokenURL
    }
}
