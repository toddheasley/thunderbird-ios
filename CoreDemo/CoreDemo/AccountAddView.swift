import Core
import SwiftUI

struct AccountAddView: View {
    @Environment(AccountManager.self) private var accountManager: AccountManager
    @State private var isSearching: Bool = false
    @State private var emailAddress: String = ""
    @State private var account: Account?
    @FocusState private var isFocused: Bool

    private var isDisabled: Bool { !emailAddress.isEmailAddress || isSearching }

    private func search() async {
        accountManager.error = nil
        isSearching = true
        do {
            account = try await .autoconfig(emailAddress, isJMAPAvailable: accountManager.isJMAPAvailable)
        } catch {
            accountManager.error = AccountError(error) ?? .autoconfig(error)
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
                    .focused($isFocused, equals: true)
                    .onAppear {
                        isFocused = true
                    }
                    .onSubmit {
                        Task { await search() }
                    }
                Button(action: {
                    Task { await search() }
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
        .error()
    }
}

#Preview {
    AccountAddView()
        .padding()
}
