/// ``IMAPClient`` throws `IMAPError`.
public enum IMAPError: Error, CustomStringConvertible, Equatable {
    case alreadyConnected
    case notConnected
    case timedOut(seconds: Int64)
    case underlying(String)

    init(_ error: Error) {
        self = error as? Self ?? .underlying(error.localizedDescription)
    }

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .alreadyConnected: "Client already connected"
        case .notConnected: "Client not connected"
        case .underlying(let string): "Underlying: \(string)"
        }
    }
}
