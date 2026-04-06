import Account
import SwiftUI

struct AccountEditView: View {
    @Environment(AccountManager.self) private var accountManager: AccountManager
    @State private var account: Account

    init(_ account: Account = Account(name: "")) {
        self.account = account
    }

    // MARK: View
    var body: some View {
        ContentUnavailableView("Account Edit View", systemImage: "person.crop.circle")
    }
}
