import Core
import SwiftUI

struct AccountMainView: View {
    init(_ account: Account? = nil) {
        id = account?.id
    }

    @Environment(AccountManager.self) private var accountManager: AccountManager
    @State private var isPresented: Bool = false
    private let id: UUID?

    private var account: Account? {
        guard let id else {
            return nil
        }
        return accountManager.account(for: id)
    }

    // MARK: View
    var body: some View {
        if let account {
            ContentUnavailableView {
                Label("\(account.name)", systemImage: "envelope")
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .navigationTitle(account.name)
            .toolbar {
                Button(action: {
                    isPresented = true
                }) {
                    Label("Edit account", systemImage: "gearshape")
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    AccountEditView(account)
                }
                .presentationDragIndicator(.visible)
            }
        } else {
            ContentUnavailableView {
                Label("No account selected", systemImage: "envelope")
            }
        }
    }
}
