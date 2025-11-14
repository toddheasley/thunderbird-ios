import Account
import SwiftUI

@main
struct App: SwiftUI.App {
    @State private var accounts: Accounts = Accounts()
    @State private var featureFlags: FeatureFlags = FeatureFlags(distribution: .current)

    // MARK: App
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(accounts).environment(featureFlags)
        }
    }
}

