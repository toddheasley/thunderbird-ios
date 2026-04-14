import Core
import SwiftUI

struct AccountListView: View {
    @Environment(AccountManager.self) private var accountManager: AccountManager
    @State private var isPresented: Bool = false

    // MARK: View
    var body: some View {
        List {
            ForEach(accountManager.allAccounts, id: \.self) { account in
                NavigationLink(destination: {
                    AccountEditView(account)
                }) {
                    Text(account.name)
                }
            }
            .onDelete { indexSet in
                accountManager.deleteAccounts(at: indexSet)
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
            EditButton()
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
