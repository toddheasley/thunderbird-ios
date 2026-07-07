import Core
import SwiftUI

struct EmailView: View {
    init(_ email: Email? = nil, account: Account? = nil) {
        if let account {
            emailManager = EmailManager(email, account: account)
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

    private func refresh() async {
        guard let emailManager else { return }
        isRefreshing = true
        await emailManager.refreshEmail()
        isRefreshing = false
    }

    // MARK: View
    var body: some View {
        VStack {
            if let email: Email = emailManager?.email {
                EmailListItem(email)
                    .padding()
                Divider()
            }
            ScrollView {

            }
            .refreshable {
                await refresh()
            }
        }
        .overlay {
            if emailManager == nil {
                ContentUnavailableView {
                    Label("Email not found", systemImage: "questionmark.folder")
                }
                .background()
            }
        }
        .task {
            await refresh()
        }
    }
}
