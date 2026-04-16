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
                    AccountMainView(account)
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
            }
        }
        .navigationTitle("Accounts")
        .toolbar {
            #if os(iOS)
            EditButton()
            #endif
            Button(action: {
                isPresented = true
            }) {
                Label("Add account", systemImage: "plus")
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                AccountAddView()
            }
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    @Previewable @State var accountManager: AccountManager = AccountManager()

    AccountListView()
        .environment(accountManager)
}

private extension AccountManager {
    func deleteAccounts(at indexSet: IndexSet) {
        let accounts: [Account] = indexSet.compactMap { allAccounts[$0] }
        for account in accounts {
            delete(account)
        }
    }
}
