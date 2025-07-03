import JMAP
import SwiftUI

struct JMAPView: View {
    @Environment(JMAPDemo.self) private var jmapDemo: JMAPDemo
    
    // MARK: View
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(jmapDemo.session?.username ?? "")
                Divider()
                ForEach(jmapDemo.mailboxes) { mailbox in
                    NavigationLink(value: mailbox) {
                        HStack {
                            Image(systemName: mailbox.systemName)
                            Text(mailbox.name)
                        }
                    }
                }
            }
            .navigationDestination(for: Mailbox.self) { mailbox in
                MailboxView(mailbox.id)
            }
            .containerRelativeFrame(.horizontal)
        }
    }
}

#Preview("JMAP View") {
    @Previewable @State var jmapDemo: JMAPDemo = JMAPDemo()

    JMAPView()
        .environment(jmapDemo)
}
