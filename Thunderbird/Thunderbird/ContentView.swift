import SwiftUI
import Account

struct ContentView: View {
    @State private var isPresented: Bool = false
    @State private var hasAuthorization: Bool = false
    @Environment(Accounts.self) private var accounts: Accounts

    // MARK: View
    var body: some View {
        NavigationStack {
            // TODO: Maybe a different check later
            if hasAuthorization {
                // TODO: Go to logged in state
                WelcomeScreen($isPresented)
            } else {
                WelcomeScreen($isPresented)
            }
        }
        .sheet(isPresented: $isPresented) {
            ManualAccount()
        }
        .onChange(of: accounts.allAccounts, initial: true) {
            guard !accounts.allAccounts.isEmpty else { return }
            hasAuthorization =
                accounts
                .allAccounts[0].incomingServer?.authorization != nil
                && accounts
                    .allAccounts[0].outgoingServer?.authorization != nil
            isPresented = false
        }

        .presentationDragIndicator(.visible)
    }
}

#Preview("Content View") {
    ContentView()
}
