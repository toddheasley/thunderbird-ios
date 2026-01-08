/// ``IMAPClient`` throws `IMAPError`.
public enum IMAPError: Error, CustomStringConvertible, Equatable {
    case alreadyConnected
    case commandFailed(String)
    case notConnected
    case serverDisconnected
    case timedOut(seconds: Int64)
    case underlying(String)

    init(_ error: Error) {
        self = error as? Self ?? .underlying(error.localizedDescription)
    }

    static func commandFailed(_ command: any IMAPCommand) -> Self {
        .commandFailed(command.description)
    }

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .alreadyConnected: "Already connected"
        case .commandFailed(let description): "\(description) failed"
        case .notConnected: "Not connected"
        case .serverDisconnected: "Server disconnected"
        case .timedOut(let seconds): "Timed out after \(seconds) \(seconds == 1 ? "second" : "seconds")"
        case .underlying(let description): "Underlying: \(description)"
        }
    }
}
