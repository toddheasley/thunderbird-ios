import Foundation

public enum Token: CustomStringConvertible, Equatable, ExpressibleByStringLiteral {
    case bearer(String)

    var value: String {
        switch self {
        case .bearer(let token): token
        }
    }

    // MARK: CustomStringConvertible
    public var description: String { value }

    // MARK: ExpressibleByStringLiteral
    public init(stringLiteral value: String) {
        self = .bearer(value)
    }
}
