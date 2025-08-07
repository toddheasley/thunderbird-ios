import Foundation

public struct Account: Codable, Equatable, Identifiable {
    public let name: String

    public init(name: String, id: UUID = UUID()) {
        self.name = name
        self.id = id
    }

    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id  // Account equality based on UUID exclusively
    }

    // MARK: Identifiable
    public let id: UUID
}
