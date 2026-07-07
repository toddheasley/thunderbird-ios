// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

/// Manage and display a single ``Email`` message for a given ``Account``.
@Observable
public final class EmailManager {
    public let account: Account
    public private(set) var email: Email?
    public var error: AccountError?

    public init(_ email: Email? = nil, account: Account) {
        self.account = account
        self.email = email
    }

    public func refreshEmail() async {
        do {
            switch account.emailProtocol {
            case .imap:
                let client: IMAPClient = try await account.imapClient
            case .jmap:
                let client: JMAPClient = try await account.jmapClient
            }
        } catch {
            self.error = AccountError(error)
        }
    }
}
