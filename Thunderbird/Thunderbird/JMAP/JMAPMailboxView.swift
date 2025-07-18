import JMAP
import SwiftUI

struct JMAPMailboxView: View {
    let mailbox: Mailbox

    init(_ mailbox: Mailbox) {
        self.mailbox = mailbox
    }

    @Environment(JMAPObject.self) private var jmap: JMAPObject
    @State private var emails: [Email] = []

    // MARK: View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10.0) {
                Text(mailbox.name)
                    .bold()
                Divider()
                ForEach(emails) { email in
                    NavigationLink(value: email) {
                        Text(email.subject ?? "nil")
                    }
                }
            }
            .navigationDestination(for: Email.self) { email in
                JMAPEmailView(email)
            }
            .padding()
            .containerRelativeFrame(.horizontal)
            .onAppear {
                Task {
                    emails = await jmap.emails(in: mailbox)
                }
            }
        }
        .refreshable {
            emails = await jmap.emails(in: mailbox)
        }
    }
}
