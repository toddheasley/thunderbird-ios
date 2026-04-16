public enum AccountError: CustomStringConvertible, Error, Equatable {
    case autoconfig(Error)
    case fileManager(Error)
    case imap(IMAPError)
    case jmap(JMAPError)
    case mime(MIMEError)
    case smtp(SMTPError)

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .autoconfig(let error): "Autoconfiguration: \(error)"
        case .fileManager(let error): "FileManager: \(error)"
        case .imap(let error): "IMAP: \(error)"
        case .jmap(let error): "JMAP: \(error)"
        case .mime(let error): "MIME: \(error)"
        case .smtp(let error): "SMTP: \(error)"
        }
    }

    // MARK: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.description == rhs.description
    }
}
