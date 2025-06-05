import Foundation

extension URLRequest {
    mutating func setAuthorization(_ token: String) {
        setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    mutating func setContentType(_ value: String = "application/json; charset=utf-8") {
        setValue(value, forHTTPHeaderField: "Content-Type")
    }
    
    mutating func setAccept(_ value: String = "application/json") {
        setValue(value, forHTTPHeaderField: "Accept")
    }
    
    // https://jmap.io/spec-core.html#localisation-of-user-visible-strings
    mutating func setAcceptLanguage(_ value: String = Locale.acceptedLanguages()) {
        setValue(value, forHTTPHeaderField: "Accept-Language")
    }
}
