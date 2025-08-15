import SwiftUI

struct EmailView: View {

    // MARK: View
    var body: some View {
        ContentUnavailableView("email_title", systemImage: "envelope.open")
    }
}

#Preview("Email View") {
    EmailView()
}
