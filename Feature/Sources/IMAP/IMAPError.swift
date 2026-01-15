/// ``IMAPClient`` throws `IMAPError`.
public enum IMAPError: Error, CustomStringConvertible, Equatable {
    case underlying(String)
    case example

    init(_ error: Error) {
        self = error as? Self ?? .underlying(error.localizedDescription)
    }

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .underlying(let string): "Underlying: \(string)"
        case .example: "Example"
        }
    }
}
