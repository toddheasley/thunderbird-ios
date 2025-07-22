import JMAP
import SwiftUI

@main
struct App: SwiftUI.App {
    @State private var jmap: JMAPObject = JMAPObject()

    // MARK: App
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(jmap)
        }
    }
}
