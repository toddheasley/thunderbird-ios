import Foundation

public struct Email: Identifiable, Sendable {
    public let sender: EmailAddress
    public let recipients: [EmailAddress]
    public let subject: String
    public let date: Date
    public let parts: [Data]

    public var body: Data {
        var data: Data = Data()
        for part in parts {
            data.append("\(line)--\(boundary)\(line)".data(using: .utf8)!)
            data.append(part)
        }
        data.append("\(line)--\(boundary)--\(line)".data(using: .utf8)!)
        return data
    }

    public var contentType: String {
        "multipart/mixed; boundary=\"\(boundary)\""
    }

    public var messageID: String {
        // Format: https://www.jwz.org/doc/mid.html
        let id: String = id.uuidString.components(separatedBy: "-").first!
        let local: String = "\(Int(date.timeIntervalSince1970)).\(id)"
        guard let host: String = sender.host else {
            return "<\(local)>"
        }
        return "<\(local)@\(host)>"
    }

    public init(
        sender: EmailAddress,
        recipients: [EmailAddress] = [],
        subject: String = "",
        date: Date = Date(),
        body parts: [Data] = [],
        id: UUID = UUID()
    ) {
        self.sender = sender
        self.recipients = recipients
        self.subject = subject
        self.date = date
        self.parts = parts
        self.id = id
    }

    // MARK: Identifiable
    public let id: UUID
}

private var boundary: String { "|/\\/\\/\\/\\/\\/|" }
private var line: String { "\r\n" }
