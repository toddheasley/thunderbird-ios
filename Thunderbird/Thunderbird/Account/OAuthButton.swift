// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Account
import AuthenticationServices
import Autoconfiguration
import SwiftUI

struct OAuthButton: View {
    init(_ account: Binding<Account>, error: Binding<Error?> = .constant(nil), action: @escaping @MainActor () -> Void = {}) {
        self.action = action
        _account = account
        _error = error
    }

    @Environment(\.webAuthenticationSession) private var webAuthenticationSession: WebAuthenticationSession
    @Binding private var account: Account
    @Binding private var error: Error?
    @State private var authConfig: OAuth2.Configuration?
    private let action: () -> Void

    private func configure() async {
        error = nil
        do {
            guard let emailAddress: EmailAddress = account.emailAddress else {
                throw AccountError.emailAddressNotFound
            }
            authConfig = try await OAuth2.configuration(emailAddress.value)

        } catch {
            self.error = error
        }
    }

    private func authenticate() async {
        error = nil
        do {
            guard let emailAddress: EmailAddress = account.emailAddress else {
                throw AccountError.emailAddressNotFound
            }
            guard let authConfig else {
                throw AccountError.emailAddressNotSupported
            }
            let pkce: OAuth2.PKCE = OAuth2.PKCE()
            let authURL: URL = try await webAuthenticationSession.authenticate(
                using: authConfig.authURL(hint: emailAddress.value, pkce: pkce),
                callback: .customScheme("\(Bundle.main.schemes.first!)"), additionalHeaderFields: [:]
            )
            let code: String = try authURL.code
            await getToken(code: code, pkce: pkce)
            action()
        } catch {
            self.error = AccountError(error)
        }
    }

    private func getToken(code: String, pkce: OAuth2.PKCE) async {
        error = nil
        do {
            guard let emailAddress: EmailAddress = account.emailAddress else {
                throw AccountError.emailAddressNotFound
            }
            guard let authConfig else {
                throw AccountError.emailAddressNotSupported
            }
            let request: URLRequest = try URLRequest.token(authConfig, code: code, pkce: pkce)
            let data: Data = try await URLSession.shared.data(for: request).0
            let response: TokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            let refreshToken: Token = .refresh(response.refreshToken)
            let token: Token = .bearer(
                response.accessToken,
                Date(timeIntervalSinceNow: TimeInterval(response.expiresIn))
            )
            account.authenticationType = .oAuth2
            account.authorization = .oauth(user: emailAddress.value, token: token, refresh: refreshToken)
        } catch {
            self.error = error
        }
    }

    // MARK: View
    var body: some View {
        HStack {
            switch account.authorization {
            case .oauth(_, let token, let refresh):
                Text("\(token.description) / \(refresh.description)")
            default:
                Text("No token stored")
            }
            Spacer()
            Button(action: {
                Task { await authenticate() }
            }) {
                Text("account_oauth_sign_in_button")
            }
            .buttonStyle(.borderedProminent)
            .disabled(authConfig == nil)
        }
        .task {
            await configure()
        }
    }
}

#Preview("OAuth Button") {
    @Previewable @State var account: Account = Account("example@thunderbird.net")
    @Previewable @State var error: Error?

    OAuthButton($account, error: $error) {
        print(account.authorization)
    }
    .padding()
}

private extension URL {
    var code: String {
        get throws {
            guard let queryItems: [URLQueryItem] = URLComponents(string: absoluteString)?.queryItems,
                let code: String = queryItems.filter({ $0.name == "code" }).first?.value
            else {
                throw URLError(.badServerResponse)
            }
            return code
        }
    }
}
