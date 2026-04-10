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
    init(_ string: String) {
        self.init(ByteBuffer(string: string))
    }

    // MARK: CustomStringConvertible
    public var description: String { String(data: Data(bytes), encoding: .utf8) ?? "" }
}
