/// Standard email services/protocols to query DNS SRV records for
public enum Service: String, CaseIterable, CustomStringConvertible {
    case autodiscover, imap, imaps, jmap, smtp, submission

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .autodiscover: rawValue.capitalized
        case .imap, .jmap, .smtp: rawValue.uppercased()
        case .imaps: Self.imap.description
        default: rawValue
        }
    }
}
