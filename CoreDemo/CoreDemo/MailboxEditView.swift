import Core
import SwiftUI

struct MailboxEditView: View {
    init(_ mailbox: Mailbox) {
        id = mailbox.id
    }

    @Environment(MailboxManager.self) private var mailboxManager: MailboxManager?
    private let id: String
    private var isAdding: Bool { mailboxManager?.mailbox(for: id) == nil }

    // MARK: View
    var body: some View {
        ContentUnavailableView("Mailbox", systemImage: "folder")
            .navigationTitle(isAdding ? "Add Mailbox" : "Edit Mailbox")
            .toolbar {
                Button(action: {

                }) {
                    Label("Save", systemImage: "checkmark")
                }
                .buttonStyle(.borderedProminent)
            }
            .error()
    }
}
