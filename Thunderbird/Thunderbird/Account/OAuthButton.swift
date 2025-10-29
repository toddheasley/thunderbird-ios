import AuthenticationServices
import Autoconfiguration
import SwiftUI

struct OAuthButton: View {
    let emailAddress: EmailAddress

    init(_ emailAddress: EmailAddress = "") {
        self.emailAddress = emailAddress
    }

    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @State private var request: OAuth2.Request?
    @State private var error: Error?

    private func authenticate() async {
        do {
            error = nil
            guard let request else { return }
            let url: URL = try await webAuthenticationSession.authenticate(
                using: request.authURL(hint: emailAddress),
                callback: .customScheme("\(Bundle.main.schemes.first!)"),
                additionalHeaderFields: [:])
            print(url)
        } catch {
            self.error = error
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

#Preview("OAuth Button") {
    OAuthButton("example@thunderbird.net")
}
