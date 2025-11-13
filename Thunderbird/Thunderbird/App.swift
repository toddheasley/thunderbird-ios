import Account
import SwiftUI

@main
struct App: SwiftUI.App {
    @State private var accounts: Accounts = Accounts()

    // MARK: App
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(accounts).environment(\.featureFlags, FeatureFlags(distribution: .current))
        }
    }
}

extension EnvironmentValues {
    @Entry var featureFlags = FeatureFlags(distribution: .debug)
}

