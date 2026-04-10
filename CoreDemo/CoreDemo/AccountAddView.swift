import Core
import SwiftUI

struct AccountAddView: View {
    @State private var isSearching: Bool = false
    @State private var emailAddress: String = ""
    @State private var account: Account?
    @State private var error: Error?

    private var isDisabled: Bool { !emailAddress.isEmailAddress || isSearching }

    private func search() async {
        error = nil
        isSearching = true
        do {
            let config: ClientConfig = try await URLSession.shared.autoconfig(emailAddress).config
            account = Account(emailAddress, provider: config.emailProvider)
        } catch {
            self.error = error
        }
        isSearching = false
    }

    // MARK: View
    var body: some View {
        VStack {
            Spacer()
            HStack {
                TextField("Email address", text: $emailAddress)
                    #if os(iOS)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .submitLabel(.search)
                    #endif
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
                            await search()
                        }
                    }
                Button(action: {
                    Task {
                        await search()
                    }
                }) {
                    Label("Search configurations", systemImage: "magnifyingglass")
                }
                .disabled(isDisabled)
            }
            .labelStyle(.iconOnly)
            .padding(.horizontal)
            Spacer()
            NavigationLink("Configure manually") {
                AccountEditView()
            }
            .padding()
        }
        .navigationTitle("Add Account")
        .navigationDestination(item: $account) { account in
            AccountEditView(account)
        }
    }
}
