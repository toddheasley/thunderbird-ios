import Foundation

public struct EmailProvider: Decodable {
    public let displayName: String
    public let displayShortName: String
    public let documentation: [URL]
    public let domain: String
    public let servers: [Server]
}
