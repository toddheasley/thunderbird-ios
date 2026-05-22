import Foundation

public struct Mailbox: CustomStringConvertible, Hashable, Identifiable {
    public typealias Role = JMAP.Mailbox.Role
    public typealias Rights = JMAP.Mailbox.Rights

    public let role: Role?
    public let rights: Rights
    public let name: String
    public let isSubscribed: Bool
    public let unreadEmails: Int?
    public let totalEmails: Int?

    public init(
        _ name: String,
        role: Role? = nil,
        rights: Rights = Rights(),
        isSubscribed: Bool = false,
        unreadEmails: Int? = nil,
        totalEmails: Int? = nil,
        id: String = UUID().uuidString(1)
    ) {
        self.role = role
        self.rights = rights
        self.name = name
        self.isSubscribed = isSubscribed
        self.unreadEmails = unreadEmails
        self.totalEmails = totalEmails
        self.id = id
    }

    // MARK: CustomStringConvertible
    public var description: String { name }

    // MARK: Identifiable
    public let id: String
}

extension Mailbox {
    init(_ mailbox: (IMAP.Mailbox, IMAP.Mailbox.Status?)) {
        self.init(
            mailbox.0.path.name.description,
            role: mailbox.0.path.suggestedRole,
            rights: Rights(),
            isSubscribed: !mailbox.0.attributes.filter({ $0 == .subscribed }).isEmpty,
            unreadEmails: mailbox.1?.unseenCount,
            totalEmails: mailbox.1?.messageCount
        )
    }

    init(_ mailbox: JMAP.Mailbox) {
        self.init(
            mailbox.name,
            role: mailbox.role,
            rights: mailbox.rights,
            isSubscribed: mailbox.isSubscribed,
            unreadEmails: mailbox.unreadEmails,
            totalEmails: mailbox.totalEmails,
            id: mailbox.id
        )
    }
}

extension IMAP.Mailbox.Path {
    var suggestedRole: Mailbox.Role? {
        let rawValue: String = lastPathComponent.lowercased().components(separatedBy: .whitespaces)[0]
        if let role: Mailbox.Role = Mailbox.Role(rawValue: rawValue) {
            return role
        } else if rawValue.hasPrefix("spam") || rawValue.hasPrefix("junk") || rawValue.hasPrefix("bulk") {
            return .junk
        } else if rawValue.hasPrefix("deleted") {
            return .trash
        } else if rawValue.hasPrefix("draft") {
            return .drafts
        } else {
            return nil
        }
    }
}
