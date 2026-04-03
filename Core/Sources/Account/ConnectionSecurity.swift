import Autoconfiguration
import IMAP

public typealias ConnectionSecurity = IMAP.ConnectionSecurity

extension ConnectionSecurity {
    init(_ socketType: EmailProvider.Server.SocketType) {
        switch socketType {
        case .startTLS: self = .startTLS
        case .ssl: self = .tls
        }
    }
}
