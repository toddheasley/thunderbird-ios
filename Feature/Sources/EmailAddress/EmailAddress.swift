import Foundation

/// Shared email address model suitable for IMAP, JMAP and SMTP
public struct EmailAddress: Codable, CustomStringConvertible, Equatable, ExpressibleByStringLiteral, Identifiable, Sendable {
    public let value: String
    public let label: String?

    public var host: String? {
        URL(string: "http://\(value.components(separatedBy: "@").last!)")?.host()
    }

    public var local: String? {
        value.contains("@") ? value.components(separatedBy: "@").dropLast().joined(separator: "@") : nil
    }

    public init(_ value: String, label: String? = nil) {
        let label: String = label?.trimmed() ?? ""
        self.value = value.trimmed()
        self.label = !label.isEmpty ? label : nil
    }

    // MARK: Codable
    public func encode(to encoder: any Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        try container.encode(description)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value: String = try container.decode(String.self)
        self.init(stringLiteral: value)
    }

    // MARK: CustomStringConvertible
    public var description: String { !(label ?? "").isEmpty ? "\(label!) <\(value)>" : value }

    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id  // Equality ignores label
    }

    // MARK: ExpressibleByStringLiteral
    public init(stringLiteral value: StringLiteralType) {
        let components: [String] = value.trimmed().components(separatedBy: "<")
        if components.count == 2, components[1].hasSuffix(">") {
            // "Example Name <name@example.com>"
            self.init("\(components[1].dropLast())", label: components[0].trimmed())
        } else {
            // "name@example.com"
            self.init(components[0].trimmed())
        }
    }

    // MARK: Identifiable
    public var id: String { value }
}

private extension String {
    func trimmed() -> Self {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
