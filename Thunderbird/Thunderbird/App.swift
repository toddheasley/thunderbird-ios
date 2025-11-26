import Account
import SwiftUI

@main
struct App: SwiftUI.App {
    @State private var accounts: Accounts = Accounts()
    @State private var showAlert = false

    // MARK: App
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(accounts)
                if showAlert {
                    FeatureNotImplementedView()
                }
            }
        }.onChange(of: AlertManager.shared.showAlert) {
            showAlert = AlertManager.shared.showAlert
        }
        #if os(macOS)
        .defaultSize(width: 768.0, height: 512.0)
        .windowResizability(.contentMinSize)
        .windowStyle(.hiddenTitleBar)
        #endif
    }
}
