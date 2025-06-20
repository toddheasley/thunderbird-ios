import Foundation

public struct Thread: Identifiable {
    public let emailIDs: [String]

    // MARK: Identifiable
    public let id: String
}

extension Thread {
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

    static let prefix: String = "Thread/"
}
