import Foundation

public struct ClientConfig: Decodable {
    public let emailProvider: EmailProvider?
    public let webMail: WebMail?
}
