import Foundation

public struct Mailbox: CustomStringConvertible, Decodable, Identifiable {
    public enum Role: String, CaseIterable, CustomStringConvertible, Decodable, Identifiable {
        case inbox, archive, drafts, sent, junk, trash

        // MARK: CustomStringConvertible
        public var description: String { rawValue }

        // MARK:  Identifiable
        public var id: String { rawValue }
    }

    public struct Rights: Decodable {
        public let mayReadItems: Bool
        public let mayAddItems: Bool
        public let mayRemoveItems: Bool
        public let maySetSeen: Bool
        public let maySetKeywords: Bool
        public let mayCreateChild: Bool
        public let mayRename: Bool
        public let mayDelete: Bool
        public let maySubmit: Bool
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

    public var rights: Rights { myRights }

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

    static let prefix: String = "Mailbox/"
}
