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
            OAuth2Button(username)
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
