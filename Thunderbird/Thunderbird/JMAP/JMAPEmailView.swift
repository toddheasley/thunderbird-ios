import JMAP
import SwiftUI

struct JMAPEmailView: View {
    let email: Email

    init(_ email: Email) {
        self.email = email
    }

    @Environment(JMAPObject.self) private var jmap: JMAPObject
    @State private var thread: [Email] = []

    // MARK: View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10.0) {
                Text(email.from?.first?.email ?? "<address>")
                Text(email.subject ?? "<subject>")
                    .bold()
                Divider()
                Text(email.preview ?? "")
            }
            .padding()
            .containerRelativeFrame(.horizontal)
            .onAppear {
                Task {
                    thread = await jmap.thread(for: email)
                }
            }
        }
        .refreshable {
            thread = await jmap.thread(for: email)
        }
    }
}
