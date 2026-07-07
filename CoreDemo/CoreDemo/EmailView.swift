import Core
import SwiftUI

struct EmailView: View {
    init(_ account: Account? = nil) {
        if let account {
            emailManager = EmailManager(nil, account: account)
        }
        id = account?.id
    }

    @Environment(AccountManager.self) private var accountManager: AccountManager
    @State private var emailManager: EmailManager?
    @State private var isRefreshing: Bool = false
    private let id: UUID?

    private var account: Account? {
        guard let id else {
            return nil
        }
        return accountManager.account(for: id)
    }

    // MARK: View
    var body: some View {
        ContentUnavailableView(
            label: {
                Label("No email found", systemImage: "questionmark.folder")
            },
            actions: {
                Button(action: {

                }) {
                    Text("Refresh")
                }
            }
        )
    }
}
