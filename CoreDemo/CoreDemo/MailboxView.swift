import Core
import SwiftUI

struct MailboxView: View {
    var mailbox: Mailbox? { mailboxManager?.mailbox(for: id) }

    init(_ mailbox: Mailbox) {
        id = mailbox.id
    }

    @Environment(MailboxManager.self) private var mailboxManager: MailboxManager?
    @State private var emails: [Email] = []
    @State private var isRefreshing: Bool = false
    @State private var isPresented: Bool = false
    private let id: String

    private func refresh() async {
        guard let mailboxManager, let mailbox else { return }
        isRefreshing = true
        emails = await mailboxManager.emails(in: mailbox)
        isRefreshing = false
    }

    // MARK: View
    var body: some View {
        if let mailbox, let mailboxManager {
            List {
                ForEach(emails) { email in
                    NavigationLink(destination: {
                        Text(email.description)
                    }) {
                        EmailListItem(email)
                    }
                }
            }
            .overlay {
                if !isRefreshing, emails.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label("No emails found", systemImage: "questionmark.text.page")
                        },
                        actions: {
                            Button(action: {
                                Task {
                                    await refresh()
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
            .navigationTitle(mailbox.name)
            .toolbar {
                Button(action: {
                    isPresented = true
                }) {
                    Label("Edit mailbox", systemImage: "gearshape")
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    MailboxEditView(mailbox)
                        .environment(mailboxManager)
                }
                .presentationDragIndicator(.visible)
            }
        } else {
            ContentUnavailableView {
                Label("No mailbox selected", systemImage: "questionmark.folder")
            }
        }
    }
}

struct EmailListItem: View {
    let email: Email

    init(_ email: Email) {
        self.email = email
    }

    private var sender: String {
        guard let address: EmailAddress = email.from.first as? EmailAddress ?? email.sender.first as? EmailAddress else {
            return "(no sender)"
        }
        return address.label ?? address.value
    }

    private var date: String {
        guard let date: Date = email.sent ?? email.received else {
            return "(no date)"
        }
        return DateFormatter.shared.string(from: date)
    }

    private var subject: String {
        guard let subject: String = email.subject, !subject.isEmpty else {
            return "(no subject)"
        }
        return subject
    }

    // MARK: View
    var body: some View {
        VStack(spacing: 10.0) {
            HStack {
                Text(sender)
                    .bold()
                Spacer()
                Text(date)
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text(subject)
                Spacer()
            }
        }
    }
}

private extension DateFormatter {
    static let shared: DateFormatter = .short

    static var short: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }
}
