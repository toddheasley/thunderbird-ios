import Core
import SwiftUI

struct MailboxEditView: View {
    var mailbox: Mailbox? { mailboxManager?.mailbox(for: id) ?? mailboxManager?.mailbox(name) }

    init(_ mailbox: Mailbox) {
        isSubscribed = mailbox.isSubscribed
        role = mailbox.role
        rights = mailbox.rights
        name = mailbox.name
        id = mailbox.id
    }

    @Environment(MailboxManager.self) private var mailboxManager: MailboxManager?
    @Environment(\.dismiss) var dismiss
    @State private var isPresented: Bool = false
    @State private var isSubscribed: Bool
    @State private var role: Mailbox.Role?
    @State private var rights: Mailbox.Rights
    @State private var name: String = ""
    private let id: String
    private var isAdding: Bool { mailbox == nil }

    private func save() {
        guard let mailboxManager else { return }
        if isAdding {
            Task {
                await mailboxManager.createMailbox(name)
            }
        } else if let mailbox {
            Task {
                if mailbox.name != name {
                    await mailboxManager.rename(mailbox, to: name)
                }
                if mailbox.isSubscribed != isSubscribed {
                    switch isSubscribed {
                    case false: await mailboxManager.unsubscribe(mailbox)
                    case true: await mailboxManager.subscribe(mailbox)
                    }
                }
            }
        }
    }

    // MARK: View
    var body: some View {
        VStack(spacing: 10.0) {
            Toggle(isOn: $isSubscribed) {
                Text("Subscribed")
            }
            .disabled(isAdding)
            HStack {
                Text("Display Name")
                Spacer()
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.top)
            TextField("", text: $name)
                .disableAutoFormatting()
                .disabled(!rights.mayRename)
                .font(.title)
            if let role {
                HStack {
                    Text("Assigned Role")
                    Spacer()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top)
                HStack {
                    Label(role.description, systemImage: role.systemImage)
                    Spacer()
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle(isAdding ? "Add Mailbox" : "Edit Mailbox")
        .toolbar {
            Button(action: { save() }) {
                Label("Save", systemImage: "checkmark")
            }
            .buttonStyle(.borderedProminent)
        }
        .error()
    }
}
