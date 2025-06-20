import Foundation

/// Email represents a single message, pre-decoded and modeled, no client-side MIME parsing required; part of [JMAP mail protocol.](https://jmap.io/spec-mail.html#emails)
public struct Email: Identifiable {
    public struct Address: CustomStringConvertible, Decodable {
        public let email: String
        public let name: String?

        init(_ email: String, name: String? = nil) {
            self.email = email
            self.name = name
        }

        // MARK: CustomStringConvertible
        public var description: String {
            !(name ?? "").isEmpty ? "\"\(name!)\" <\(email)>" : "\(email)"
        }
    }

    public struct AddressGroup: Decodable {
        public let adresses: [Address]
        public let name: String?
    }

    // Metadata
    public let blobID: String
    public let threadID: String
    public let messageID: String
    public let mailboxIDs: [String: Bool]
    public let keywords: [String: Bool]
    public let size: Int
    public let receivedAt: Date?
    public let sentAt: Date?
    
    public let subject: String
    
    
    /*
    messageId
    inReplyTo
    sender
    from
    to
    cc
    bcc
    replyTo
    hasAttachment
    preview */

    
    

    // MARK: Identifiable
    public let id: String
}

extension Email {
    struct GetMethod: Method {
        let ids: [String]

        init(_ accountID: String, ids: [String], id: UUID = UUID()) throws {
            guard !accountID.isEmpty else {
                throw MethodError.accountNotFound
            }
            guard !ids.isEmpty else {
                throw MethodError.invalidArguments
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
                    "ids": ids
                ],
                id.uuidString
            ]
        }
    }

    struct QueryMethod: Method {
        let collapseThreads: Bool
        let calculateTotal: Bool

        init(_ accountID: String, collapseThreads: Bool = false, calculateTotal: Bool = false, id: UUID = UUID()) throws {
            guard !accountID.isEmpty else {
                throw MethodError.accountNotFound
            }
            self.accountID = accountID
            self.collapseThreads = collapseThreads
            self.calculateTotal = calculateTotal
            self.id = id
        }

        // MARK: Method
        static let name: String = "\(prefix)query"
        let accountID: String
        let id: UUID

        var object: [Any] {
            [
                Self.name,
                [
                    "accountId": accountID,
                    "collapseThreads": collapseThreads,
                    "calculateTotal": calculateTotal
                ],
                id.uuidString
            ]
        }
    }

    static let prefix: String = "Email/"
}
