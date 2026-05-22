// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import NIOCore
import NIOIMAPCore

public typealias Mailbox = NIOIMAPCore.MailboxInfo

extension Mailbox {
    public typealias Attribute = NIOIMAPCore.MailboxInfo.Attribute
    public typealias Name = NIOIMAPCore.MailboxName
    public typealias Status = NIOIMAPCore.MailboxStatus
}

extension MailboxName: @retroactive CustomStringConvertible {
    public init(_ string: String) {
        self.init(ByteBuffer(string: string))
    }

    // MARK: CustomStringConvertible
    public var description: String { String(data: Data(bytes), encoding: .utf8) ?? "" }
}
