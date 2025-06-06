import SwiftUI
import Mail

@main
struct App: SwiftUI.App {
    @State private var mail: Mail = Mail()

    // MARK: App
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(mail)
        }
    }
}
