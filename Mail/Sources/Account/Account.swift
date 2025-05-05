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
    
    // MARK: CaseIterable
    public static var allCases: [Self] {
        (try? FileManager.default.accounts) ?? []
    }
}
