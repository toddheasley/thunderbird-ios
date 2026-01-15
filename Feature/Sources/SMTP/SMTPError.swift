/// ``SMTPClient`` throws `SMTPError`.
public enum SMTPError: Error, CustomStringConvertible, Equatable {
    case emailRecipientNotFound
    case remoteConnectionClosed
    case requiredTLSNotConfigured
    case responseNotDecoded
    case response(String)

    init(_ error: Error) {
        self = error as? Self ?? .response(error.localizedDescription)
    }

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .emailRecipientNotFound: "Email recipient not found"
        case .remoteConnectionClosed: "Remote connection closed"
        case .requiredTLSNotConfigured: "Required TLS not configured"
        case .responseNotDecoded: "Response not decoded"
        case .response(let string): "Response: \(string)"
        }
    }
}
