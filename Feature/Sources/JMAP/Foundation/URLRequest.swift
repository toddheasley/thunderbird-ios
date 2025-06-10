import Foundation

extension URLRequest {

    /// Request JMAP session object from a service provider.
    /// - Parameter host: Host name of the JMAP service provider; e.g., `api.fastmail.com`
    /// - Parameter token: OAuth bearer token to authenticate with service provider
    /// - Returns: `URLRequest` configured to GET an authenticated session with a JMAP service provider
    public static func session(_ host: String, port: Int? = nil, token: String) throws -> Self {
        var request: Self = Self(url: try .session(host, port: port))
        try request.setJMAPHeaders(token)
        return request
    }

    mutating func setJMAPHeaders(_ token: String) throws {
        try setAuthorization(token)
        setAcceptLanguage()
        setContentType()
        setAccept()
    }

    /// Authorize HTTP request with session OAuth token.
    mutating func setAuthorization(_ token: String) throws {
        guard !token.isEmpty else {
            throw URLError(.userAuthenticationRequired)
        }
        setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    /// Ask JMAP server to  [localize user-visible strings](https://jmap.io/spec-core.html#localisation-of-user-visible-strings) according to device configured locales.
    mutating func setAcceptLanguage(_ value: String = Locale.acceptedLanguages()) {
        setValue(value, forHTTPHeaderField: "Accept-Language")
    }

    /// Declare HTTP request body content as JSON.
    mutating func setContentType(_ value: String = "application/json; charset=utf-8") {
        setValue(value, forHTTPHeaderField: "Content-Type")
    }

    /// Ask JMAP server to serialize HTTP response as JSON.
    mutating func setAccept(_ value: String = "application/json") {
        setValue(value, forHTTPHeaderField: "Accept")
    }
}
