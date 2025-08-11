@testable import Account
import Testing
import Foundation

struct AuthorizationTests {
    @Test func user() {
        #expect(Authorization.basic(user: "user@example.com", password: "").user == "user@example.com")
        #expect(Authorization.oauth(user: "user@example.com", token: "").user == "user@example.com")
    }

    @Test func value() {
        #expect(Authorization.basic(user: "user@example.com", password: "P@$sW0rd!").value == "Basic dXNlckBleGFtcGxlLmNvbTpQQCRzVzByZCE=")
        #expect(Authorization.oauth(user: "user@example.com", token: "fmu1-1e911257e86b1f194daa-0-a89faae5c11f").value == "Bearer fmu1-1e911257e86b1f194daa-0-a89faae5c11f")
    }

    @Test func password() {
        #expect(Authorization.basic(user: "user@example.com", password: "P@$sW0rd!").password == "dXNlckBleGFtcGxlLmNvbTpQQCRzVzByZCE=")
        #expect(Authorization.oauth(user: "user@example.com", token: "fmu1-1e911257e86b1f194daa-0-a89faae5c11f").password == "fmu1-1e911257e86b1f194daa-0-a89faae5c11f")
    }

    @Test func userInit() {
        #expect(Authorization(user: "user@example.com", password: "dXNlckBleGFtcGxlLmNvbTpQQCRzVzByZCE=") == .basic(user: "user@example.com", password: "P@$sW0rd!"))
        #expect(Authorization(user: "user@example.com", password: "fmu1-1e911257e86b1f194daa-0-a89faae5c11f") == .oauth(user: "user@example.com", token: "fmu1-1e911257e86b1f194daa-0-a89faae5c11f"))
    }
}
