import EmailAddress
import Foundation
import NIOCore

enum Request {
    case hello(String)
    case startTLS
    case authLogin
    case authUser(String)
    case authPassword(String)
    case mailFrom(EmailAddress)
    case recipient(EmailAddress)
    case data
    case transferData(Email)
    case quit
}

struct RequestEncoder: MessageToByteEncoder {

    // MARK: MessageToByteEncoder
    typealias OutboundIn = Request

    func encode(data: OutboundIn, out: inout ByteBuffer) throws {
        switch data {
        case .hello(let hostname):
            out.writeString("EHLO \(hostname)")
        case .startTLS:
            out.writeString("STARTTLS")
        case .authLogin:
            out.writeString("AUTH LOGIN")
        case .authUser(let value), .authPassword(let value):
            out.writeBytes((value.data(using: .utf8) ?? Data()).base64EncodedData())
        case .mailFrom(let emailAddress):
            out.writeString("MAIL FROM:<\(emailAddress.value)>")
        case .recipient(let emailAddress):
            out.writeString("RCPT TO:<\(emailAddress.value)>")
        case .data:
            out.writeString("DATA")
        case .transferData(let email):
            out.writeString("From: \(email.sender)\(line)")
            out.writeString("To: \(email.recipients.map { $0.description }.joined(separator: " "))\(line)")
            out.writeString("Date: \(email.iso8601Date)\(line)")  // "EEE, dd MMM yyyy HH:mm:ss Z"
            out.writeString("Message-ID: \(email.messageID)\(line)")
            out.writeString("Subject: \(email.subject)\(line)")
            // out.writeString("MIME-Version: 1.0\(line)")
            out.writeString("Content-Type: \(email.contentType)\(line)")
            out.writeBytes(email.body)
            out.writeString("\(line).")
        case .quit:
            out.writeString("QUIT")
        }
        out.writeString(line)
    }
}
