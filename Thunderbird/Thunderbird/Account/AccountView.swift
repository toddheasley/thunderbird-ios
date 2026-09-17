// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Bolt
import Core
import SwiftUI

enum AccountDestination: String, CaseIterable, CustomStringConvertible {
    case add, auto, edit

    // MARK: CustomStringConvertible
    var description: String { rawValue }
}

struct AccountView: View {
    init(_ emailAddress: EmailAddress) {
        self.init(Account(emailAddress))
    }

    init(_ account: Account = Account()) {
        self.account = account
        destination = account.servers.isEmpty ? .add : .edit
    }

    @Environment(AccountManager.self) private var accountManager: AccountManager
    @State private var account: Account
    @State private var path: NavigationPath = NavigationPath()
    private let destination: AccountDestination

    // MARK: View
    var body: some View {
        NavigationStack(path: $path) {
            switch destination {
            case .edit:
                AccountEditView($account)
            default:
                AccountAddView($account, path: $path, autofocus: true)
                    .navigationDestination(for: AccountDestination.self) { destination in
                        switch destination {
                        case .auto: AccountAutoView($account, path: $path)
                        default: AccountEditView($account)
                        }
                    }
            }
        }
    }
}

#Preview("Account View") {
    @Previewable @State var accountManager: AccountManager = AccountManager()

    AccountView("Pat Example <example@thunderbird.net>")
        .environment(accountManager)
}
