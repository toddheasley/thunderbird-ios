import SwiftUI

struct AccountsView: View {
    init(_ showSettings: Binding<Bool> = .constant(false)) {
        _showSettings = showSettings
    }

    @Binding private var showSettings: Bool

    // MARK: View
    var body: some View {
        VStack {
            ContentUnavailableView("accounts_title", systemImage: "person.3")
            Button(action: {
                showSettings = true
            }) {
                Label("prefs_title", systemImage: "gear")
            }
        }
    }
}

#Preview("Accounts View") {
    @Previewable @State var showSettings: Bool = false
    AccountsView($showSettings)
        .alert("Show settings", isPresented: $showSettings) {

        }
}
