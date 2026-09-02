// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Account
import SwiftUI

struct ContentView: View {
    @Environment(AccountManager.self) private var accountManager: AccountManager
    @State private var isPresented: Bool = false

    // MARK: View
    var body: some View {
        if accountManager.allAccounts.isEmpty {
            WelcomeScreen($isPresented)
                .sheet(isPresented: $isPresented) {
                    ManualAccount()
                        .presentationDragIndicator(.visible)
                }
        } else {
            EmailListView()
                .task {
                    isPresented = false
                    await accountManager.checkAndRenewExpirations()
                }
        }
    }
}

#Preview("Content View") {
    @Previewable @State var accountManager: AccountManager = AccountManager()

    ContentView()
        .environment(accountManager)
}
