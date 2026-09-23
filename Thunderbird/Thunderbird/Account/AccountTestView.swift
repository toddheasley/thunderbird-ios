// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Bolt
import Core
import SwiftUI

struct AccountTestView: View {
    let account: Account

    init(_ account: Account) {
        self.account = account
    }

    // MARK: View
    var body: some View {
        ContentUnavailableView("\(account.name)", systemImage: "burst.fill")
    }
}
