import Foundation

/// Mailboxes are the primary mechanism for organizing ``Email`` within an ``Account``, part of [JMAP mail.](https://jmap.io/spec-mail.html#mailboxes)
public struct Mailbox: CustomStringConvertible, Decodable, Identifiable, Sendable {
    public enum Role: String, CaseIterable, CustomStringConvertible, Decodable, Identifiable, Sendable {
        case inbox, archive, drafts, sent, junk, trash

        // MARK: CustomStringConvertible
        public var description: String { rawValue }

        // MARK:  Identifiable
        public var id: String { rawValue }
    }

    public struct Rights: Decodable, Sendable {
        public let mayReadItems: Bool
        public let mayAddItems: Bool
        public let mayRemoveItems: Bool
        public let maySetSeen: Bool
        public let maySetKeywords: Bool
        public let mayCreateChild: Bool
        public let mayRename: Bool
        public let mayDelete: Bool
        public let maySubmit: Bool

        init(
            mayReadItems: Bool = true,
            mayAddItems: Bool = true,
            mayRemoveItems: Bool = true,
            maySetSeen: Bool = true,
            maySetKeywords: Bool = true,
            mayCreateChild: Bool = true,
            mayRename: Bool = true,
            mayDelete: Bool = true,
            maySubmit: Bool = true
        ) {
            self.mayReadItems = mayReadItems
            self.mayAddItems = mayAddItems
            self.mayRemoveItems = mayRemoveItems
            self.maySetSeen = maySetSeen
            self.maySetKeywords = maySetKeywords
            self.mayCreateChild = mayCreateChild
            self.mayRename = mayRename
            self.mayDelete = mayDelete
            self.maySubmit = maySubmit
        }
    }

    public let name: String
    public let parentID: String?
    public let role: Role?
    public let sortOrder: Int
    public let totalEmails: Int
    public let totalThreads: Int
    public let unreadEmails: Int
    public let unreadThreads: Int
    public let isSubscribed: Bool

    public var rights: Rights { myRights }  // Rename `myRights` to `rights`

    public init(name: String, parentID: String? = nil, isSubscribed: Bool = true, id: String) {
        self.name = name
        self.parentID = parentID
        role = nil
        sortOrder = 0
        totalEmails = 0
        totalThreads = 0
        unreadEmails = 0
        unreadThreads = 0
        self.isSubscribed = isSubscribed
        myRights = Rights()
        self.id = id
    }

    let myRights: Rights

    // MARK: CustomStringConvertible
    public var description: String { name }

    // MARK:  Identifiable
    public let id: String
}

extension Mailbox {
    struct GetMethod: Method {
        let ids: [String]?

        init(_ accountID: String, ids: [String]? = nil, id: UUID = UUID()) throws {
            guard !accountID.isEmpty else {
                throw MethodError.accountNotFound
            }
            self.accountID = accountID
            self.ids = ids
            self.id = id
        }

        // MARK: Method
        static let name: String = "\(prefix)get"
        let accountID: String
        let id: UUID

        var object: [Any] {
            [
                Self.name,
                [
                    "accountId": accountID,
                    "ids": ids as Any
                ],
                id.uuidString
            ]
        }
    }

    struct SetMethod: Method {
        let actions: [MethodAction]

        init(_ accountID: String, actions: [MethodAction], id: UUID = UUID()) throws {
            guard !accountID.isEmpty else {
                throw MethodError.accountNotFound
            }
            self.accountID = accountID
            self.actions = actions
            self.id = id
        }

        // MARK: Method
        static let name: String = "\(prefix)set"
        let accountID: String
        let id: UUID

        var object: [Any] {
            var object: [String: Any] = [
                "accountId": accountID
            ]
            for action in actions {
                switch action {
                case .create(let mailbox), .update(let mailbox):
                    object["\(action)"] = mailbox
                case .destroy(let ids):
                    object["\(action)"] = ids
                }
            }
            return [
                Self.name,
                object,
                id.uuidString
            ]
        }
    }

    static let prefix: String = "Mailbox/"
}
