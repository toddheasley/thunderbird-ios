import Foundation

/// Multipart part content disposition and parameters described in [RFC 2183](https://www.rfc-editor.org/rfc/rfc2183)
///
/// Instruct mail client to display decoded body part inline, in message, or link as an attachment. Optionally include metadata for source file.
public enum ContentDisposition: CustomStringConvertible, Equatable, RawRepresentable {
    public struct File {

        /// Suggested attachment filename and extension; expressed in ASCII characters
        public let filename: String?
        public let creationDate: Date?
        public let modificationDate: Date?
        public let readDate: Date?

        /// Approximate attachment file size in bytes; i.e.,  `Data.count`
        public let size: Int?  // Bytes (`Data.count`)

        public init(
            filename: String? = nil,
            creationDate: Date? = nil,
            modificationDate: Date? = nil,
            readDate: Date? = nil,
            size: Int? = nil
        ) {
            self.filename = !(filename?.ascii ?? "").isEmpty ? filename : nil  // Prevent empty name
            self.creationDate = creationDate
            self.modificationDate = modificationDate
            self.readDate = readDate
            self.size = (size ?? 0) > 0 ? size : nil  // Prevent zero-byte size
        }

        /// Decode `File`from `ContentDisposition` parameter strings.
        public init(_ parameters: [String]) {
            lazy var formatter: DateFormatter = RFC822DateFormatter()
            var filename: String? = nil
            var date: (creation: Date?, modification: Date?, read: Date?) = (nil, nil, nil)
            var size: Int? = nil
            for parameter in parameters {
                let parameter: [String] = parameter.components(separatedBy: "=").map {
                    $0.trimmed().removing(.quotes)
                }
                guard parameter.count == 2, !parameter[1].isEmpty else {
                    continue
                }
                switch parameter[0] {
                case "filename":
                    filename = parameter[1]
                case "creation-date":
                    date.creation = formatter.date(from: parameter[1])
                case "modification-date":
                    date.modification = formatter.date(from: parameter[1])
                case "read-date":
                    date.read = formatter.date(from: parameter[1])
                case "size":
                    size = Int(parameter[1])
                default:
                    continue
                }
            }
            self.init(
                filename: filename,
                creationDate: date.creation,
                modificationDate: date.modification,
                readDate: date.read,
                size: size
            )
        }

        var parameters: [String] {
            lazy var formatter: DateFormatter = RFC822DateFormatter()
            var parameters: [String] = []
            if let filename {
                parameters.append("filename=\"\(filename)\"")
            }
            if let creationDate {
                parameters.append("creation-date=\"\(formatter.string(from: creationDate))\"")
            }
            if let modificationDate {
                parameters.append("modification-date=\"\(formatter.string(from: modificationDate))\"")
            }
            if let readDate {
                parameters.append("read-date=\"\(formatter.string(from: readDate))\"")
            }
            if let size {
                parameters.append("size=\(size)")
            }
            return parameters
        }
    }

    case attachment(File)
    case inline(File)
    case extensionToken

    public static var attachment: Self { .attachment(File()) }
    public static var inline: Self { .inline(File()) }

    public init?(_ parameters: [String]) {
        switch parameters[0] {
        case "attachment":
            self = .attachment(File(Array(parameters.dropFirst())))
        case "inline":
            self = .inline(File(Array(parameters.dropFirst())))
        case "extension-token":
            self = .extensionToken
        default:
            return nil
        }
    }

    public var parameters: [String] {
        switch self {
        case .attachment(let file), .inline(let file): [value] + file.parameters
        case .extensionToken: [value]
        }
    }

    var value: String {
        switch self {
        case .attachment: "attachment"
        case .inline: "inline"
        case .extensionToken: "extension-token"
        }
    }

    // MARK: CustomStringConvertible
    public var description: String { rawValue }

    // MARK: RawRepresentable
    public var rawValue: String { parameters.joined(separator: "; ") }

    public init?(rawValue: String) {
        var parameters: [String] = []
        for (index, value) in rawValue.components(separatedBy: ";").enumerated() {
            let last: Int = parameters.count - 1
            if index == 0 || value.contains("=") {
                parameters.append(value)
            } else if parameters[last].contains("=") {
                parameters[last] += ";\(value)"  // Repair RFC822 date-time split on semicolon
            } else {
                continue  // Skip unexpected parameters
            }
        }
        self.init(parameters.map { $0.trimmed() })
    }
}
