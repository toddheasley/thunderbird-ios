import JMAP
import SwiftUI

struct JMAPSessionView: View {
    let session: Session

    init(_ session: Session) {
        self.session = session
    }

    @Environment(JMAPObject.self) private var jmap: JMAPObject
    @Environment(\.openURL) private var openURL

    @State private var mailboxes: [Mailbox] = []

    // MARK: View
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10.0) {
                    Text(session.username)
                        .bold()
                    Divider()
                    ForEach(mailboxes) { mailbox in
                        NavigationLink(value: mailbox) {
                            HStack {
                                Image(systemName: mailbox.systemName)
                                Text(mailbox.name)
                            }
                        }
                    }
                }
                .navigationDestination(for: Mailbox.self) { mailbox in
                    JMAPMailboxView(mailbox)
                }
                .padding(.vertical)
                .padding()
                .containerRelativeFrame(.horizontal)
                .onAppear {
                    Task {
                        mailboxes = await jmap.mailboxes()
                    }
                }
            }
            .refreshable {
                mailboxes = await jmap.mailboxes()
            }
            HStack {
                Button(action: {
                    jmap.token = ""
                }) {
                    Label("Sign out", systemImage: "xmark.circle.fill")
                }
                .buttonStyle(.bordered)
                .padding()
                Button(action: {
                    guard let url = URL(string: "https://www.thunderbird.net/en-US/donate/") else { return }
                    openURL(url)
                }) {
                    Text("donation_support")
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }

        }
    }
}
