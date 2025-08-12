import Foundation

public struct Account: Codable, Equatable, Identifiable {
    public let name: String
    public let deletePolicy: DeletePolicy

    public init(
        name: String,
        deletePolicy: DeletePolicy = .never,
        id: UUID = UUID()
    ) {
        self.name = name
        self.deletePolicy = deletePolicy
        self.id = id
    }

    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id  // Account equality based on UUID exclusively
    }

    // MARK: Identifiable
    public let id: UUID
}
