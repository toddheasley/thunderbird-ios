@testable import Autoconfiguration
import Foundation
import Testing

struct OAuth2Tests {
    @Test func decoderInit() throws {
        let oauth2: [OAuth2] = try JSONDecoder().decode([OAuth2].self, from: data)
        #expect(oauth2[0].scope == [
            "mail-w"
        ])
        #expect(oauth2[1].scope == [
            "https://mail.google.com/",
            "https://www.googleapis.com/auth/contacts",
            "https://www.googleapis.com/auth/calendar",
            "https://www.googleapis.com/auth/carddav"
        ])
        #expect(oauth2[2].scope == [
            "mail-w"
        ])
    }
}

// swift-format-ignore
let data: Data = """
[
    {
        "authURL": "https://api.login.aol.com/oauth2/request_auth",
        "issuer": "login.aol.com",
        "scope": "mail-w",
        "tokenURL": "https://api.login.aol.com/oauth2/get_token"
    },
    {
        "authURL": "https://accounts.google.com/o/oauth2/auth",
        "issuer": "accounts.google.com",
        "scope": "https://mail.google.com/ https://www.googleapis.com/auth/contacts https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/carddav",
        "tokenURL": "https://www.googleapis.com/oauth2/v3/token"
    },
    {
        "authURL": "https://api.login.yahoo.com/oauth2/request_auth",
        "issuer": "login.yahoo.com",
        "scope": "mail-w",
        "tokenURL": "https://api.login.yahoo.com/oauth2/get_token"
    }
]
""".data(using: .utf8)!
