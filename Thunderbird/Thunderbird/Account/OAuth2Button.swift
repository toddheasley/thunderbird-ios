import AuthenticationServices
import Autoconfiguration
import SwiftUI

struct OAuth2Button: View {
    let emailAddress: EmailAddress

    init(_ emailAddress: EmailAddress = "") {
        self.emailAddress = emailAddress
    }

    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @State private var request: OAuth2.Request?
    @State private var error: Error?

    private func configure() async {
        do {
            error = nil
            request = try await OAuth2.request(emailAddress)
        } catch {
            self.error = error
        }
    }

    private func authenticate() async {
        do {
            error = nil
            guard let request else { return }
            let url: URL =
                try await webAuthenticationSession
                .authenticate(
                    using: request.authURL,
                    callback: .customScheme("\(Bundle.main.schemes.first!)"),
                    additionalHeaderFields: [:]
                )
            print(url)
        } catch {
            self.error = error
        }
    }

    // MARK: View
    var body: some View {
        Button(action: {
            Task {
                await authenticate()
            }
        }) {
            Text("account_oauth_sign_in_button")
        }
        .disabled(request == nil)
        .task {
            await configure()
        }
    }
}

#Preview("OAuth2 Button") {
    OAuth2Button("example@thunderbird.net")
}

extension OAuth2.Request: @retroactive CaseIterable, @retroactive Equatable {

    // MARK: AOL
    static var aol: Self {
        try! Self(
            authURI: "https://api.login.aol.com/oauth2/request_auth",
            tokenURI: "https://api.login.aol.com/oauth2/get_token",
            redirectURI: "\(Bundle.main.schemes.first!)://oauth2redirect",
            scope: [
                "mail-w"
            ],
            clientID: "dj0yJmk9MVJGcHpSejNUcTU3JmQ9WVdrOWMwMHhjSFZqTkhRbWNHbzlNQT09JnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PWNk",
            hosts: [
                "aol.com"
            ]
        )
    }

    // MARK: Fastmail
    static var fastmail: Self {
        try! Self(
            authURI: "https://api.fastmail.com/oauth/authorize",
            tokenURI: "https://api.fastmail.com/oauth/refresh",
            redirectURI: "\(Bundle.main.schemes.first!)://oauth2redirect",
            scope: [
                "https://www.fastmail.com/dev/protocol-imap",
                "https://www.fastmail.com/dev/protocol-smtp"
            ],
            clientID: "353e41ae",
            hosts: [
                "messagingengine.com",
                "fastmail.com"
            ]
        )
    }

    // MARK: Google
    static var google: Self {
        try! Self(
            authURI: "https://accounts.google.com/o/oauth2/v2/auth",
            tokenURI: "https://oauth2.googleapis.com/token",
            redirectURI: "\(Bundle.main.schemes.first!):/oauth2redirect",
            scope: [
                "https://mail.google.com/"
            ],
            clientID: "560629489500-no2mlau7e4vn3psh5esaiodgri09jrj9.apps.googleusercontent.com",
            hosts: [
                "googlemail.com",
                "google.com",
                "gmail.com"
            ]
        )
    }

    // MARK: Microsoft
    static var microsoft: Self {
        try! Self(
            authURI: "https://login.microsoftonline.com/common/oauth2/v2.0/authorize",
            tokenURI: "https://login.microsoftonline.com/common/oauth2/v2.0/token",
            redirectURI: "msauth://\(Bundle.main.schemes.first!)/eaXDuh6T3KFWjcJhsoaObT9OayU%3D",
            scope: [
                "profile",
                "openid",
                "email",
                "https://outlook.office.com/IMAP.AccessAsUser.All",
                "https://outlook.office.com/SMTP.Send",
                "offline_access"
            ],
            clientID: "e6f8716e-299d-4ed9-bbf3-453f192f44e5",
            hosts: [
                "office365.com",
                "outlook.com"
            ]
        )
    }

    // MARK: Yahoo!
    static var yahoo: Self {
        try! Self(
            authURI: "https://api.login.yahoo.com/oauth2/request_auth",
            tokenURI: "https://api.login.yahoo.com/oauth2/get_token",
            redirectURI: "\(Bundle.main.schemes.first!)://oauth2redirect",
            scope: [
                "mail-w"
            ],
            clientID: "dj0yJmk9bXRhTkZod2xmY3JrJmQ9WVdrOVUyUTRXRGQ0Tlc4bWNHbzlNQT09JnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PTkx",
            hosts: [
                "yahoo.com"
            ]
        )
    }

    // MARK: Thundermail
    static var thundermail: Self {
        try! Self(
            authURI: "https://auth.tb.pro/realms/tbpro/protocol/openid-connect/auth",
            tokenURI: "https://auth.tb.pro/realms/tbpro/protocol/openid-connect/token",
            redirectURI: "\(Bundle.main.schemes.first!)://oauth2redirect",
            scope: [
                "openid",
                "profile",
                "email",
                "offline_access"
            ],
            clientID: "mobile-android-thunderbird",
            hosts: [
                "tb.pro",
                "thundermail.com"
            ]
        )
    }

    // MARK: CaseIterable
    public static var allCases: [Self] {
        [
            .aol,
            .fastmail,
            .google,
            .microsoft,
            .yahoo,
            .thundermail
        ]
    }

    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.clientID == rhs.clientID
    }
}

extension OAuth2 {
    static func request(_ emailAddress: EmailAddress) async throws -> Self.Request {
        let records: [MXRecord] = try await DNSResolver.queryMX(emailAddress)
        for record in records {
            print(record.host)
            for request in Request.allCases {
                guard request.matches(record.host) else { continue }
                return request
            }
        }
        throw URLError(.unsupportedURL)
    }
}
