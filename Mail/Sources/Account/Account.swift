import Foundation

public struct Account: Codable, Identifiable {
    public let name: String

    public init(name: String, id: UUID = UUID()) {
        self.name = name
        self.id = id
    }

    // MARK: Identifiable
    public let id: UUID
}

extension Account: CaseIterable {
    public func delete() throws {
        try FileManager.default.write(Self.allCases.filter { $0.id != id }, to: .accounts)
    }

    public func save(at index: Int? = nil) throws {
        var accounts: [Self] = Self.allCases
        let index: Int? = index ?? accounts.firstIndex(where: { $0.id == id })  // Target index OR current index OR nil (append to end)
        accounts = accounts.filter { $0.id != id }  // Remove existing account
        if let index, index < accounts.count {
            accounts.insert(self, at: index) // Insert at previous or new target index
        } else {
            accounts.append(self)  // Append to end of array
        }
        try FileManager.default.write(accounts, to: .accounts)
    }
    
    public static func deleteAll() {
        for account in Self.allCases {
            try? account.delete()
        }
    }
    
    // MARK: CaseIterable
    public static var allCases: [Self] {
        (try? FileManager.default.readAccounts(from: .accounts)) ?? []
    }
}
