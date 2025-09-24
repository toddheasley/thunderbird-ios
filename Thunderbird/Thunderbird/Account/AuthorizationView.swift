import Account
import AuthenticationServices
import Autoconfiguration
import SwiftUI

struct AuthorizationView: View {
    let username: String
    let authenticationType: AuthenticationType

    init(_ authorization: Binding<Authorization>, for username: String, authenticationType: AuthenticationType = .oAuth2) {
        self.username = username
        self.authenticationType = authenticationType
        _authorization = authorization
        switch authorization.wrappedValue {
        case .basic(_, let password), .oauth(_, let password):
            self.password = password
        case .none:
            break
        }
    }

    @Binding private var authorization: Authorization
    @State private var password: String = ""

    // MARK: View
    var body: some View {
        switch authenticationType {
        case .password:
            SecureField("Password", text: $password)
                .onChange(of: password) {
                    authorization = .basic(user: username, password: password)
                }
        case .oAuth2:
            OAuthButton(username)
                .disabled(true)
        case .none:
            EmptyView()
        }
    }
}

#Preview("Authorization View") {
    @Previewable @State var authorization: Authorization = .none

    AuthorizationView($authorization, for: "example@thunderbird.net")
        .padding()
}

struct OAuthButton: View {
    let emailAddress: EmailAddress

    init(_ emailAddress: EmailAddress, oAuth: OAuth2? = nil) {
        self.emailAddress = emailAddress
        self.oAuth = oAuth
    }

    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @State private var oAuth: OAuth2?
    @State private var error: Error?

    private func configureOAuth() async {
        do {
            let config: ClientConfig = try await URLSession.shared.autoconfig(emailAddress).config
            guard let oAuth: OAuth2 = config.oAuth2 else {
                throw URLError(.resourceUnavailable)
            }
            self.oAuth = oAuth
        } catch {
            self.error = error
        }
    }

    // MARK: View
    var body: some View {
        Button(action: {
            Task {
                do {
                    guard let oAuth else {
                        throw URLError(.resourceUnavailable)
                    }
                    let url: URL = try await webAuthenticationSession.authenticate(
                        using: oAuth.authURL,
                        callback: .https(host: oAuth.tokenURL.host() ?? "", path: oAuth.tokenURL.path()),
                        preferredBrowserSession: .shared,
                        additionalHeaderFields: [:]
                    )
                    print(url.absoluteString)
                } catch {
                    self.error = error
                }
            }
        }) {
            if let oAuth {
                Text("Sign in with \(oAuth.issuer)")
            } else if error != nil {
                Text("Loading OAuth Failed")
            } else {
                HStack {
                    Text("Loading OAuth…  ")
                    ProgressView()
                }
                .task {
                    // TODO: Debounce email address changes
                    await configureOAuth()
                }
            }
        }
        .buttonStyle(.bordered)
        .disabled(oAuth == nil)
    }
}

#Preview("OAuth Button") {
    OAuthButton("gmail.com")
        .padding()
}
