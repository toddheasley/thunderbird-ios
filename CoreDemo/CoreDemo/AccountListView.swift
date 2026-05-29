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
                    MailboxListView(account)
                }) {
                    Text(account.name)
                }
                .swipeActions {
                    Button(
                        role: .destructive,
                        action: {
                            accountManager.delete(account)
                        }
                    ) {
                        Label("Delete", systemImage: "trash")
                    }
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
            }
        }
        .navigationTitle("Accounts")
        .toolbar {
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
