// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Bolt
import Core
import SwiftUI

struct AccountAutoView: View {
    init(_ account: Binding<Account>, path: Binding<NavigationPath> = .constant(NavigationPath())) {
        _account = account
        _path = path
    }

    @Environment(AccountManager.self) private var accountManager: AccountManager
    @Environment(\.dismiss) private var dismiss: DismissAction
    @Binding private var account: Account
    @Binding private var path: NavigationPath

    // MARK: View
    var body: some View {
        ContentUnavailableView("AUTO", systemImage: "burst.fill")
            .onAppear {
                print(account.emailAddress?.description ?? "nil")
            }
    }
}

/*
let autoconfig: (config: ClientConfig, source: Source) = try await URLSession.shared.autoconfig(emailAddress)
isSearching = false
config = autoconfig.config
source = autoconfig.source */

/*
guard let account else { return }
accountManager.set(account)
dismiss() */
