import SwiftUI

struct MailboxView: View {

    // MARK: View
    var body: some View {
        ContentUnavailableView("mailbox_title", systemImage: "tray.full")
    }
}

#Preview("Mailbox View") {
    MailboxView()
}
