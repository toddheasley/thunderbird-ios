// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

public enum Token: CustomStringConvertible, Equatable, ExpressibleByStringLiteral {
    case bearer(String)

    var value: String {
        switch self {
        case .bearer(let token): token
        }
    }

    // MARK: CustomStringConvertible
    public var description: String { value }

    // MARK: ExpressibleByStringLiteral
    public init(stringLiteral value: String) {
        self = .bearer(value)
    }
}
