import JMAP
import SwiftUI

struct ContentView: View {
    @Environment(JMAPObject.self) private var jmap: JMAPObject
    @State private var isPresented: Bool = false

    // MARK: View
    var body: some View {
        NavigationStack {
            if let session = jmap.session {
                JMAPSessionView(session)
            } else {
                WelcomeScreen($isPresented)
            }
        }
        .sheet(isPresented: $isPresented) {
            JMAPTokenView()
                .presentationDragIndicator(.visible)
                .presentationDetents([
                    .medium
                ])
        }
        .onChange(of: jmap.session) {
            isPresented = false
        }
    }
}

#Preview("Content View") {
    @Previewable @State var jmap: JMAPObject = JMAPObject()

    ContentView()
        .environment(jmap)
}
