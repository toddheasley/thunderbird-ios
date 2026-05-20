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
                        MailboxListItem(mailbox, selected: $mailbox)
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

struct MailboxListItem: View {
    let mailbox: Mailbox

    init(_ mailbox: Mailbox, selected: Binding<Mailbox?>) {
        self.mailbox = mailbox
        _selected = selected
    }

    @Binding private var selected: Mailbox?

    // MARK: View
    var body: some View {
        HStack {
            Label(mailbox.name, systemImage: mailbox.role?.systemImage ?? "folder")
            Spacer()
            MailboxStatusView(mailbox)
        }
        .swipeActions {
            Button(action: { selected = mailbox }) {
                Label("Edit", systemImage: "gearshape")
            }
            .labelStyle(.iconOnly)
        }
    }
}

struct MailboxStatusView: View {
    let unread: Int?
    let total: Int?

    init(_ mailbox: Mailbox) {
        self.init(unread: mailbox.unreadEmails, total: mailbox.totalEmails)
    }

    init(unread: Int? = nil, total: Int? = nil) {
        self.unread = unread
        self.total = total
    }

    // MARK: View
    var body: some View {
        if let total, total > 0 {
            HStack {
                if let unread, unread > 0 {
                    Text("\(unread)")
                        .foregroundStyle(.primary)
                        .bold()
                    Text("/")
                }
                Text("\(total)")
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal, 11.0)
            .padding(.vertical, 3.0)
            .background {
                Capsule()
                    .fill(.quinary.opacity(0.33))
            }
        } else {
            EmptyView()
        }
    }
}

#Preview("Mailbox Status View") {
    MailboxStatusView(unread: 3, total: 47)
}

extension Image {
    init(role: Mailbox.Role?) {
        self.init(systemName: role?.systemName ?? "folder")
    }
}

#Preview("Image") {
    VStack {
        ForEach(Mailbox.Role.allCases) { role in
            Image(role: role)
                .padding()
        }
        Image(role: nil)
            .padding()
    }
}

extension Mailbox.Role {
    var systemImage: String { systemName }

    var systemName: String {
        switch self {
        case .inbox: "tray"
        case .archive: "archivebox"
        case .drafts: "document"
        case .sent: "paperplane"
        case .junk: "xmark.bin"
        case .trash: "trash"
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
