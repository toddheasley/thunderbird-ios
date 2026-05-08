import Core
import SwiftUI

struct AccountMainView: View {
    init(_ account: Account? = nil) {
        if let account {
            mailboxManager = MailboxManager(account: account)
        }
        id = account?.id
    }

    @Environment(AccountManager.self) private var accountManager: AccountManager
    @State private var mailboxManager: MailboxManager?
    @State private var isRefreshing: Bool = false
    @State private var isPresented: Bool = false
    private let id: UUID?

    private var account: Account? {
        guard let id else {
            return nil
        }
        return accountManager.account(for: id)
    }

    private func refresh() async {
        guard let mailboxManager else { return }
        isRefreshing = true
        await mailboxManager.refreshMailboxes()
        isRefreshing = false
    }

    // MARK: View
    var body: some View {
        if let account, let mailboxManager {
            List {
                ForEach(mailboxManager.mailboxes, id: \.self) { mailbox in
                    Label(mailbox.name, systemImage: "folder")
                }
                .onDelete { indexSet in

                }
            }
            .overlay {
                if !isRefreshing, mailboxManager.mailboxes.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label("No mailboxes found", systemImage: "questionmark.folder")
                        },
                        actions: {
                            Button(action: {
                                Task {
                                    await mailboxManager.refreshMailboxes()
                                }
                            }) {
                                Text("Refresh")
                            }
                        }
                    )
                }
            }
            .refreshable {
                await refresh()
            }
            .task {
                await refresh()
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .navigationTitle(account.name)
            .toolbar {
                Button(action: {
                    isPresented = true
                }) {
                    Label("Edit account", systemImage: "gearshape")
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    AccountEditView(account)
                }
                .presentationDragIndicator(.visible)
            }
        } else {
            ContentUnavailableView {
                Label("No account selected", systemImage: "envelope")
            }
        }
    }
}
