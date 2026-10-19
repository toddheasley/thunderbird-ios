// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import NIOCore
import NIOIMAPCore

public enum Authentication: CustomStringConvertible, Equatable, Sendable {
    public typealias Mechanism = AuthenticationMechanism

    case xoauth2(_ user: String, token: String)
    case plain(_ user: String, password: String)

    public var mechanism: Mechanism {
        switch self {
        case .xoauth2: .xOAuth2
        case .plain: .plain
        }
    }

    public var user: String {
        switch self {
        case .xoauth2(let user, _), .plain(let user, _): user
        }
    }

    // MARK: CustomStringConvertible
    public var description: String {
        "\(mechanism) \"\(user)\""
    }
}

extension AuthenticationMechanism: @retroactive CustomStringConvertible {
    public static let xOAuth2: Self = Self("XOAUTH2")!

    // MARK: CustomStringConvertible
    public var description: String { String(self) }
}
