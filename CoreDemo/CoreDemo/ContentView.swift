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
                Text("Content")
            },
            detail: {
                Text("Detail")
            })
    }
}

#Preview {
    @Previewable @State var accountManager: AccountManager = AccountManager()

    ContentView()
        .environment(accountManager)
}
