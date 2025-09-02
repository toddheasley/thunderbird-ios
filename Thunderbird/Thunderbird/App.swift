import Account
import SwiftUI

@main
struct App: SwiftUI.App {

    // MARK: App
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .defaultSize(width: 768.0, height: 512.0)
        .windowResizability(.contentMinSize)
        .windowStyle(.hiddenTitleBar)
        #endif
    }
}
