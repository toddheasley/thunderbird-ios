import Core
import SwiftUI

extension View {
    func alert(_ accountManager: Binding<AccountManager>) -> some View {
        modifier(ErrorViewModifier(accountManager))
    }
}

struct ErrorViewModifier: ViewModifier {
    init(_ accountManager: Binding<AccountManager>) {
        _accountManager = accountManager
    }

    @Binding private var accountManager: AccountManager
    @State private var isPresented: Bool = false

    private var message: String {
        guard let error: Error = accountManager.error else {
            return "An unknown error occurred"
        }
        return "\(error)"
    }

    // MARK: ViewModifier
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $accountManager.hasError, actions: {}) {
                Text(message)
            }
            .onChange(of: accountManager.hasError, initial: true) {
                isPresented = accountManager.hasError
            }
    }
}
