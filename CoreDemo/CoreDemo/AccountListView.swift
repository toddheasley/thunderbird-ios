import Account
import SwiftUI

struct AccountListView: View {
    @Environment(AccountManager.self) private var accountManager: AccountManager
    @State private var isPresented: Bool = false

    // MARK: View
    var body: some View {
        ScrollView {
            VStack {
                ForEach(accountManager.allAccounts) { account in
                    Text(account.name)
                }
            }
        }
        .overlay {
            if accountManager.allAccounts.isEmpty {
                ContentUnavailableView(
                    label: {
                        Label("No accounts found", systemImage: "person.crop.circle.badge.plus")
                    },
                    actions: {
                        Button(action: {
                            isPresented = true
                        }) {
                            Text("Add account")
                        }
                    }
                )
                .containerRelativeFrame(.horizontal)
            }
        }
        .navigationTitle("Accounts")
        .toolbar {
            Button(action: {
                isPresented = true
            }) {
                Label("Add account", systemImage: "plus")
            }
            .labelStyle(.iconOnly)
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                AccountAddView()
            }
            .presentationDragIndicator(.visible)
        }
    }
}
