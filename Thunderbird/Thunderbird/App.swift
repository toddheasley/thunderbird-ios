import Account
import SwiftUI

@main
struct App: SwiftUI.App {
    @State private var accounts: Accounts = Accounts()

    // MARK: App
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(accounts)
        }
    }
}
