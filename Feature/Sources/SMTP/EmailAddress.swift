import Foundation

public struct EmailAddress: CustomStringConvertible, Equatable, ExpressibleByStringLiteral, Identifiable, Sendable {
    public let value: String
    public let label: String?

    public var host: String? {
        URL(string: "http://\(value.components(separatedBy: "@").last!)")?.host()
    }

    public init(_ value: String, label: String? = nil) {
        self.value = value
        self.label = !(label ?? "").isEmpty ? label : nil
    }

    // MARK: CustomStringConvertible
    public var description: String { !(label ?? "").isEmpty ? "\(label!) <\(value)>" : value }

    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id  // Equality ignores label
    }

    // MARK: ExpressibleByStringLiteral
    public init(stringLiteral value: StringLiteralType) {
        let components: [String] = value.trimmingCharacters(in: .whitespaces).components(separatedBy: "<")
        if components.count == 2, components[1].hasSuffix(">") {
            // "Example Name <name@example.com>"
            self.init("\(components[1].dropLast())", label: components[0].trimmingCharacters(in: .whitespaces))
        } else {
            // "name@example.com"
            self.init(components[0].trimmingCharacters(in: .whitespaces))
        }
    }

    // MARK: Identifiable
    public var id: String { value }
}
