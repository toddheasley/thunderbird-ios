// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Account
import AuthenticationServices
import Autoconfiguration
import SwiftUI

struct OAuthButton: View {
    let emailAddress: String

    init(_ emailAddress: String = "", token: Binding<Token?>, refreshToken: Binding<Token?>, error: Binding<Error?>) {
        self.emailAddress = emailAddress
        _token = token
        _error = error
        _refreshToken = refreshToken
    }

    @Binding private var token: Token?
    @Binding private var error: Error?
    @Binding private var refreshToken: Token?
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @State private var request: OAuth2.Request?

    private func authenticate() async {
        let retries = 2
        for _ in 0..<retries {
            do {
                error = nil
                guard let request else { return }
                let authURL: URL = try await webAuthenticationSession.authenticate(
                    using: request.authURL(hint: emailAddress),
                    callback: .customScheme("\(Bundle.main.schemes.first!)"), additionalHeaderFields: [:])
                let queryItems = URLComponents(string: authURL.absoluteString)?.queryItems
                let code = (queryItems?.filter({ $0.name == "code" }).first?.value)!
                await getToken(code: code)
            } catch {
                self.error = error
            }
        }

    }

    private func configure() async {
        do {
            error = nil
            request = try await OAuth2.request(emailAddress)
        } catch {
            self.error = error
        }
    }

    private func getToken(code: String) async {
        let retries = 3
        error = nil
        guard let request else { return }
        do {
            let tokenRequest = try URLRequest.token(request, code: code)
            for _ in 0..<retries {
                let (data, _) = try await URLSession.shared.data(for: tokenRequest)
                let response = try JSONDecoder().decode(TokenResponse.self, from: data)
                token = .bearer(response.access_token, Date(timeIntervalSinceNow: TimeInterval(response.expires_in)))
                refreshToken = .refresh(response.refresh_token)
            }

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
        .buttonStyle(.borderedProminent)
        .tint(.accent)
        .disabled(request == nil)
        .task {
            await configure()
        }
    }
}

struct TokenResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String
}

#Preview("OAuth Button") {
    @Previewable @State var token: Token?
    @Previewable @State var refreshToken: Token?
    @Previewable @State var error: Error?

    OAuthButton("example@thunderbird.net", token: $token, refreshToken: $refreshToken, error: $error)
}
