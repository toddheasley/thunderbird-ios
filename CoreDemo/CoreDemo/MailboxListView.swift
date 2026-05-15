import Core
import SwiftUI

struct MailboxListView: View {
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
    @State private var mailbox: Mailbox?
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
                Section {
                    ForEach(mailboxManager.mailboxes, id: \.self) { mailbox in
                        Label(mailbox.name, systemImage: "folder")
                            .swipeActions {
                                Button(action: {
                                    self.mailbox = mailbox
                                }) {
                                    Label("Edit", systemImage: "gearshape")
                                }
                                .labelStyle(.iconOnly)
                            }
                    } /*
                    .onDelete { indexSet in
                        Task { await mailboxManager.deleteMailboxes(at: indexSet) }
                    } */
                } header: {
                    Text("Mailboxes")
                } footer: {
                    Button(action: {
                        self.mailbox = Mailbox("")
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                    .buttonStyle(.bordered)
                    .labelStyle(.iconOnly)
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
            .sheet(
                item: $mailbox,
                onDismiss: {
                    mailbox = nil
                }
            ) { mailbox in
                NavigationStack {
                    MailboxEditView(mailbox)
                        .environment(mailboxManager)
                }
                .presentationDragIndicator(.visible)
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

private extension MailboxManager {
    func deleteMailboxes(at indexSet: IndexSet) async {
        let mailboxes: [Mailbox] = indexSet.compactMap { self.mailboxes[$0] }
        for mailbox in mailboxes {
            await delete(mailbox)
        }
    }
}
