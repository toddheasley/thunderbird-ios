import Core
import SwiftUI

struct ContentView: View {

    // MARK: View
    var body: some View {
        NavigationSplitView(
            sidebar: {
                AccountListView()
            },
            content: {
                ContentUnavailableView {
                    Label("Content", systemImage: "mail.stack")
                }
            },
            detail: {
                ContentUnavailableView {
                    Label("Detail", systemImage: "envelope.open")
                }
            }
        )
    }
}

#Preview {
    @Previewable @State var accountManager: AccountManager = AccountManager()

    ContentView()
        .environment(accountManager)
}
