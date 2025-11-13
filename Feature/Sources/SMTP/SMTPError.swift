public enum SMTPError: Error {
    case emailRecipientNotFound
    case remoteConnectionClosed
    case requiredTLSNotConfigured
    case responseNotDecoded
    case response(String)

    init(_ error: Error) {
        self = error as? Self ?? .response(error.localizedDescription)
    }
}
