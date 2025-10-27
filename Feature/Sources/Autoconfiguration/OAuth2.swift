import Foundation

public struct OAuth2: Decodable {
    public struct Request: Equatable {
        public let authURI: String
        public let tokenURI: String
        public let redirectURI: String
        public let responseType: String
        public let scope: [String]
        public let hosts: [String]
        public let clientID: String

        public func authURL(hint: String? = nil) -> URL {
            var components: URLComponents = URLComponents(string: authURI)!  // Validated during init
            components.queryItems = [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "redirect_uri", value: redirectURI),
                URLQueryItem(name: "response_type", value: responseType),
                URLQueryItem(name: "scope", value: scope.joined(separator: " "))
            ]
            if let hint, !hint.isEmpty {  // Prepopulate email address for specific user
                components.queryItems?.append(URLQueryItem(name: "login_hint", value: hint))
            }
            return components.url!
        }

        public func tokenURL(_ code: String) -> URL {
            var components: URLComponents = URLComponents(string: tokenURI)!  // Validated during init
            components.queryItems = [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "client_secret", value: ""),
                URLQueryItem(name: "redirect_uri", value: redirectURI),
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: code)
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

        public init(authURI: String, tokenURI: String, redirectURI: String, responseType: String, scope: [String], clientID: String, hosts: [String] = []) throws {
            guard URL(string: authURI) != nil,
                URL(string: tokenURI) != nil,  // Validate URI strings pass failable URL init
                !redirectURI.isEmpty,
                !scope.isEmpty, !(scope.first ?? "").isEmpty,
                !clientID.isEmpty
            else {
                throw URLError(.badURL)
            }
            self.authURI = authURI
            self.tokenURI = tokenURI
            self.redirectURI = redirectURI
            self.responseType = responseType
            self.scope = scope
            self.hosts = hosts
            self.clientID = clientID
        }

        public init(_ oauth2: OAuth2, redirectURI: String, responseType: String, clientID: String) throws {
            try self.init(
                authURI: oauth2.authURL.absoluteString,
                tokenURI: oauth2.tokenURL.absoluteString,
                redirectURI: redirectURI,
                responseType: responseType,
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
