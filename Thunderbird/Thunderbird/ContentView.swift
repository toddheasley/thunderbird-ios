import SwiftUI

struct ContentView: View {
    @State private var showSettings: Bool = false
    @State private var getStarted: Bool = false
    private let hasAccounts: Bool = false

    // MARK: View
    var body: some View {
        if hasAccounts {
            NavigationSplitView(
                sidebar: {
                    AccountsView($showSettings)
                },
                content: {
                    MailboxView()
                },
                detail: {
                    EmailView()
                }
            )
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .presentationDragIndicator(.visible)
            }
        } else {
            WelcomeScreen($getStarted)
                .sheet(isPresented: $getStarted) {
                    ManualAccount()
                        .presentationDragIndicator(.visible)
                }
        }
    }
}

#Preview("Content View") {
    ContentView()
}
