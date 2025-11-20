import Foundation
import MIME
import UniformTypeIdentifiers

/// ``SMTPClient`` sends `Email`.
public struct Email: Identifiable, Sendable {
    public struct Part {
        public let data: Data
        public let contentType: String
    }

    public let sender: EmailAddress
    public let recipients: [EmailAddress]
    public let copied: [EmailAddress]
    public let blindCopied: [EmailAddress]
    public let subject: String
    public let date: Date
    public let parts: [Data]

    public var body: Data {
        var data: Data = Data()
        for part in parts {
            // data.append("\(line)--\(dataBoundary)\(line)".data(using: .utf8)!)
            data.append(line.data(using: .utf8)!)
            data.append(part)
        }
        // data.append("\(line)--\(dataBoundary)--\(line)".data(using: .utf8)!)
        data.append(line.data(using: .utf8)!)
        return data
    }

    public var contentType: String { "text/plain; charset=\"UTF-8\"" }

    public var messageID: String {
        // Format: https://www.jwz.org/doc/mid.html
        let local: String = "\(Int(date.timeIntervalSince1970)).\(id.uuidString(1))"
        guard let host: String = sender.host else {
            return "<\(local)>"
        }
        return "<\(local)@\(host)>"
    }

    public init(
        sender: EmailAddress,
        recipients: [EmailAddress] = [],
        copied: [EmailAddress] = [],
        blindCopied: [EmailAddress] = [],
        subject: String = "",
        date: Date = Date(),
        body parts: [Data] = [],
        id: UUID = UUID()
    ) {
        self.sender = sender
        self.recipients = recipients
        self.copied = copied
        self.blindCopied = blindCopied
        self.subject = subject
        self.date = date
        self.parts = parts
        self.id = id
    }

    var iso8601Date: String { ISO8601DateFormatter().string(from: date) }
    var allRecipients: [EmailAddress] { recipients + copied + blindCopied }
    var dataBoundary: String { "\(id.uuidString(4))_part" }

    // MARK: Identifiable
    public let id: UUID
}

extension UUID {
    func uuidString(_ segments: Int) -> String {
        uuidString.components(separatedBy: "-").prefix(max(segments, 0)).joined(separator: "-")
    }
}

extension String {
    static var line: Self { "\r\n" }
}

var line: String { .line }
