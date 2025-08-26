import SwiftUI

struct AddAccountView: View {

    // MARK: View
    var body: some View {
        ContentUnavailableView("add_account_action", systemImage: "person.badge.plus")
    }
}

#Preview("Add Account View") {
    AddAccountView()
}
