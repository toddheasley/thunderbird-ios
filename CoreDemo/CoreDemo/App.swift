import Account
import SwiftUI

@main
struct App: SwiftUI.App {
    @State private var accountManager: AccountManager = AccountManager()

    // MARK: App
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(accountManager)
        }
    }
}
