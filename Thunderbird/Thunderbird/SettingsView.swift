import SwiftUI

struct SettingsView: View {

    // MARK: View
    var body: some View {
        ContentUnavailableView("prefs_title", systemImage: "gear")
    }
}

#Preview("Settings View") {
    SettingsView()
}
