import JMAP
import SwiftUI

@main
struct App: SwiftUI.App {
    @State private var jmapDemo: JMAPDemo = JMAPDemo()

    // MARK: App
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(jmapDemo)
        }
    }
}
