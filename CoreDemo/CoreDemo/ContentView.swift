import Account
import SwiftUI

struct ContentView: View {
    @Environment(AccountManager.self) private var accountManager: AccountManager

    // MARK: View
    var body: some View {
        VStack {
            ForEach(accountManager.allAccounts) { account in
                Text(account.name)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
