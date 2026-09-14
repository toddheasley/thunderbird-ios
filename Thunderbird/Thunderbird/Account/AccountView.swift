// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Bolt
import Core
import SwiftUI

struct AccountView: View {
    init(_ account: Account = Account(name: "")) {
        self.account = account
    }

    init(_ emailAddress: EmailAddress) {
        self.init(Account(emailAddress))
    }

    // @Environment(AccountManager.self) private var accountManager: AccountManager
    @State private var account: Account

    // MARK: View
    var body: some View {
        NavigationStack {
            if account.servers.isEmpty {
                AccountAddView($account)
            } else {
                AccountEditView($account)
            }
        }
    }
}
