import Foundation

public struct OAuth2: Decodable {
    public struct Request {
        public let authURI: String
        public let tokenURI: String
        public let redirectURI: String
        public let scope: [String]
        public let hosts: [String]
        public let clientID: String

        public var authURL: URL {
            var components: URLComponents = URLComponents(string: authURI)!
            components.queryItems = [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "redirect_uri", value: redirectURI),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: scope.joined(separator: ","))
            ]
            return components.url!
        }

        public func matches(_ host: String) -> Bool {
            for _host in hosts {
                guard host.hasSuffix(_host) else { continue }
                return true
            }
            return false
        }

        public init(authURI: String, tokenURI: String, redirectURI: String, scope: [String], clientID: String, hosts: [String] = []) throws {
            guard URL(string: authURI) != nil,
                URL(string: tokenURI) != nil,
                !redirectURI.isEmpty,
                !scope.isEmpty, !(scope.first ?? "").isEmpty,
                !clientID.isEmpty
            else {
                throw URLError(.badURL)
            }
            self.authURI = authURI
            self.tokenURI = tokenURI
            self.redirectURI = redirectURI
            self.scope = scope
            self.hosts = hosts
            self.clientID = clientID
        }

        public init(_ oauth2: OAuth2, redirectURI: String, clientID: String) throws {
            try self.init(
                authURI: oauth2.authURL.absoluteString,
                tokenURI: oauth2.tokenURL.absoluteString,
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
