import Foundation

public struct Mailbox: CustomStringConvertible, Hashable, Identifiable {
    public typealias Role = JMAP.Mailbox.Role

    public let role: Role?
    public let name: String
    public let isSubscribed: Bool

    public init(_ name: String, role: Role? = nil, isSubscribed: Bool = false, id: String = UUID().uuidString(1)) {
        self.role = role
        self.name = name
        self.isSubscribed = isSubscribed
        self.id = id
    }

    // MARK: CustomStringConvertible
    public var description: String { name }

    // MARK: Identifiable
    public let id: String
}

extension Mailbox {
    init(_ mailbox: IMAP.Mailbox) {
        self.init(
            mailbox.path.name.description,
            role: mailbox.path.name == .inbox ? .inbox : nil,
            isSubscribed: !mailbox.attributes.filter({ $0 == .subscribed }).isEmpty
        )
    }

    init(_ mailbox: JMAP.Mailbox) {
        self.init(
            mailbox.name,
            role: mailbox.role,
            isSubscribed: mailbox.isSubscribed,
            id: mailbox.id
        )
    }
}
