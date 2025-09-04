public struct ClientConfig: Decodable {
    public let emailProvider: EmailProvider?
    public let oAuth2: OAuth2?
    public let webMail: WebMail?
}
