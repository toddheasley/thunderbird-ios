public struct ClientConfig: Decodable, Equatable {
    public let emailProvider: EmailProvider?
    public let oAuth2: OAuth2?
    public let webMail: WebMail?

    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.emailProvider?.domain == rhs.emailProvider?.domain || lhs.webMail?.loginPage == rhs.webMail?.loginPage
    }
}
