import EmailAddress
import NIOIMAPCore

extension [EmailAddressListElement] {
    var addresses: [EmailAddressProtocol] { map { $0.address } }
}

extension EmailAddressListElement {
    var address: EmailAddressProtocol {
        switch self {
        case .singleAddress(let address): EmailAddress(stringLiteral: "\(address)")
        case .group(let group): EmailAddress.Group(group.children.addresses, label: "\(group)")
        }
    }
}

extension NIOIMAPCore.EmailAddressGroup: @retroactive CustomStringConvertible {

    // MARK: CustomStringConvertible
    public var description: String { groupName.readableBytesView.description }  // TODO: Decode quoted-printable/base64 (RFC 2047)
}

extension NIOIMAPCore.EmailAddress: @retroactive CustomStringConvertible {

    // MARK: CustomStringConvertible
    public var description: String {
        guard let mailbox: String = mailbox?.readableBytesView.description,
            !mailbox.isEmpty,
            let host: String = host?.readableBytesView.description,
            !host.isEmpty
        else {
            return ""
        }
        let description: String = "\(mailbox)@\(host)"
        if let personName: String = personName?.readableBytesView.description,  // TODO: Decode quoted-printable/base64 (RFC 2047)
            !personName.isEmpty
        {
            return "\(personName) <\(description)>"
        }
        return description
    }
}
