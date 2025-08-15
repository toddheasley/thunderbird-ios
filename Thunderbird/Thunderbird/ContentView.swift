import Account
import SwiftUI

struct ContentView: View {
    @Environment(Accounts.self) private var accounts: Accounts
    @State private var showSettings: Bool = false
    @State private var getStarted: Bool = false

    // MARK: View
    var body: some View {
        if accounts.allAccounts.isEmpty {
            WelcomeScreen($getStarted)
                .sheet(isPresented: $getStarted) {
                    AddAccountView()
                        .presentationDragIndicator(.visible)
                }
        } else {
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
        }
    }
}

#Preview("Content View") {
    @Previewable @State var accounts: Accounts = Accounts()

    ContentView()
        .environment(accounts)
}
