import JMAP
import SwiftUI

struct MailboxView: View {
    @Environment(JMAPDemo.self) private var jmapDemo: JMAPDemo

    var mailbox: Mailbox? {
        jmapDemo.mailboxes.filter { $0.id == id }.first
    }

    init(_ id: String) {
        self.id = id
    }

    private let id: String

    // MARK: View
    var body: some View {
        Text(mailbox?.name ?? "")
    }
}

#Preview("Mailbox View") {
    // MailboxView()
}
