import Account
import SwiftUI

struct AccountsView: View {
    @Environment(Accounts.self) private var accounts: Accounts

    // MARK: View
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 17.0) {
                    // List all accounts
                    ForEach(accounts.allAccounts) { account in
                        HStack {
                            // Delete account
                            Button(action: {
                                accounts.delete(account)
                            }) {
                                Image(systemName: "trash")
                            }
                            .foregroundStyle(.red)

                            // Edit account
                            NavigationLink(destination: {
                                EditAccountView(account)
                            }) {
                                HStack {
                                    Text(account.name)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Accounts")
            .toolbar {
                ToolbarItem(placement: .addAccount) {
                    // Add account
                    NavigationLink(destination: {
                        AddAccountView()
                    }) {
                        Label("Add Account", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview("Accounts View") {
    NavigationStack {
        AccountsView()
    }
}

private extension ToolbarItemPlacement {
    static var addAccount: Self {
        #if os(iOS)
        .bottomBar
        #else
        .automatic
        #endif
    }
}
