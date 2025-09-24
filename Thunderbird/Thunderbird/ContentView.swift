import SwiftUI

struct ContentView: View {
    @State private var isPresented: Bool = false

    // MARK: View
    var body: some View {
        WelcomeScreen($isPresented)
            .sheet(isPresented: $isPresented) {
                AccountsView()
                    .presentationDragIndicator(.visible)
            }
    }
}

#Preview("Content View") {
    ContentView()
}
