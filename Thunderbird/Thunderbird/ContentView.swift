import SwiftUI
import Account

struct ContentView: View {
    @State private var isPresented: Bool = false
    @State private var hasAuthorization: Bool = false
    @Environment(Accounts.self) private var accounts: Accounts

    // MARK: View
    var body: some View {
        VStack {
            if hasAuthorization {
                EmailListView()
                    .environment(accounts)
                    
            } else {
                NavigationStack {
                    WelcomeScreen($isPresented)
                }
                .sheet(isPresented: $isPresented) {
                    ManualAccount()
                }
                .presentationDragIndicator(.visible)

            }

        }
        .onChange(of: accounts.allAccounts, initial: true) {
            guard !accounts.allAccounts.isEmpty else {
                hasAuthorization = false
                return
            }
            hasAuthorization =
                accounts
                .allAccounts[0].incomingServer?.authorization != nil
                && accounts
                    .allAccounts[0].outgoingServer?.authorization != nil
            isPresented = false
        }
    }
}

#Preview("Content View") {
    @Previewable @State var accounts: Accounts = Accounts()

    ContentView().environment(accounts)
}
