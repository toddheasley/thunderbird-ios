import Foundation

public struct OAuth2: Decodable {
    public let authURL: URL
    public let issuer: String
    public let scope: String
    public let tokenURL: URL
}
