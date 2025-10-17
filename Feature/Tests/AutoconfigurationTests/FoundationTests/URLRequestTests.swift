@testable import Autoconfiguration
import Foundation
import Testing

struct URLRequestTests {
    @Test func token() throws {
        let request: OAuth2.Request = try OAuth2.Request(
            authURI: "https://example.com/authorize",
            tokenURI: "https://example.com/token",
            redirectURI: "com.example:/oauth2redirect",
            responseType: "code",
            scope: [
                "mail-w"
            ],
            clientID: "Cl13n+-ID",
            hosts: [
                "example.com",
                "examplemail.com"
            ]
        )
        #expect(try URLRequest.token(request, code: "0123456789").httpMethod == "POST")
        #expect(
            try URLRequest.token(request, code: "0123456789").httpBody
                == "client_id=Cl13n+-ID&client_secret=&redirect_uri=com.example:/oauth2redirect&grant_type=authorization_code&code=0123456789"
                .data(using: .utf8)
        )
        #expect(try URLRequest.token(request, code: "0123456789").url == URL(string: "https://example.com/token"))
    }
}
