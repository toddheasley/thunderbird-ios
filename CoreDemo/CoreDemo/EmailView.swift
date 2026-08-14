import Core
import SwiftUI
import WebKit

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
    @State private var page: WebPage = WebPage()
    private let id: UUID?

    private var email: Email? { emailManager?.email }

    private var account: Account? {
        guard let id else {
            return nil
        }
        return accountManager.account(for: id)
    }

    private var html: String {
        if let html: String = email?.body?.html() {
            return html
        } else if let text: String = email?.body?.text {
            return "\(text)"
        } else {
            return ""
        }
    }

    private func refresh() async {
        guard let emailManager else { return }
        isRefreshing = true
        await emailManager.refreshEmail()
        isRefreshing = false
        page.load(html: html)
    }

    // MARK: View
    var body: some View {
        if let email {
            VStack {
                EmailListItem(email)
                    .padding()
                Divider()
                ScrollView {
                    WebView(page)
                        .containerRelativeFrame([.vertical, .horizontal])
                }
                .ignoresSafeArea()
                .refreshable {
                    await refresh()
                }

            }
            .task {
                await refresh()
            }
        } else {
            ContentUnavailableView {
                Label("Email not found", systemImage: "questionmark.folder")
            }
            .background()
        }
    }
}
