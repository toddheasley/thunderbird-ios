import Foundation

/// [Media content types](https://www.iana.org/assignments/media-types/media-types.xhtml) with base types enumerated
public enum ContentType: CustomStringConvertible, Equatable, RawRepresentable, Sendable {
    case application(String)
    case audio(String)
    case example(String)
    case font(String)
    case haptics(String)
    case image(String)
    case message(String)
    case model(String)
    case multipart(String, Boundary = UUID().dataBoundary())
    case text(String, CharacterSet? = nil)
    case video(String)

    public var subtype: String {
        switch self {
        case .application(let subtype),
            .audio(let subtype),
            .example(let subtype),
            .font(let subtype),
            .haptics(let subtype),
            .image(let subtype),
            .message(let subtype),
            .model(let subtype),
            .multipart(let subtype, _),
            .text(let subtype, _),
            .video(let subtype):
            subtype
        }
    }

    public var isMultipart: Bool {
        switch self {
        case .multipart: true
        default: false
        }
    }

    var parameters: [String] {
        var parameters: [String] = [
            "\(value)/\(subtype)"
        ]
        if let boundary {
            parameters.append("boundary=\"\(boundary)\"")
        }
        if let charset {
            parameters.append("charset=\"\(charset)\"")
        }
        return parameters
    }

    var boundary: Boundary? {
        switch self {
        case .multipart(_, let boundary): boundary
        default: nil
        }
    }

    var charset: CharacterSet? {
        switch self {
        case .text(_, let charset): charset
        default: nil
        }
    }

    var value: String {
        switch self {
        case .application: "application"
        case .audio: "audio"
        case .example: "example"
        case .font: "font"
        case .haptics: "haptics"
        case .image: "image"
        case .message: "message"
        case .model: "model"
        case .multipart: "multipart"
        case .text: "text"
        case .video: "video"
        }
    }

    // MARK: CustomStringConvertible
    public var description: String { rawValue }

    // MARK: RawRepresentable
    public var rawValue: String { parameters.joined(separator: "; ") }

    public init?(rawValue: String) {
        guard let parameters: [String] = rawValue.ascii?.components(separatedBy: ";"),
            let rawValue: [String] = parameters[0].trimmed().ascii?.components(separatedBy: "/"),
            rawValue.count == 2, rawValue[1].count > 1
        else {
            return nil
        }
        switch rawValue[0].lowercased() {
        case "application":
            self = .application(rawValue[1])
        case "audio":
            self = .audio(rawValue[1])
        case "example":
            self = .example(rawValue[1])
        case "font":
            self = .font(rawValue[1])
        case "haptics":
            self = .haptics(rawValue[1])
        case "image":
            self = .image(rawValue[1])
        case "message":
            self = .message(rawValue[1])
        case "model":
            self = .model(rawValue[1])
        case "multipart":
            guard let parameter: [String] = parameters.last?.trimmed().components(separatedBy: "="),
                parameter.count == 2,
                parameter[0] == "boundary",
                let boundary: Boundary = try? Boundary(parameter[1].removing(.quotes))
            else {
                return nil
            }
            self = .multipart(rawValue[1], boundary)
        case "text":
            if let parameter: [String] = parameters.last?.trimmed().components(separatedBy: "="),
                parameter.count == 2,
                parameter[0] == "charset"
            {
                self = .text(rawValue[1], CharacterSet(rawValue: parameter[1].removing(.quotes)))
            } else {
                self = .text(rawValue[1])
            }
        case "video":
            self = .video(rawValue[1])
        default:
            return nil
        }
    }
}

extension String {

    // Standard multipart subtypes
    public static var alternative: Self { "alternative" }
    public static var mixed: Self { "mixed" }
    public static var related: Self { "related" }

    // Standard text subtypes
    public static var plain: Self { "plain" }
    public static var html: Self { "html" }
}
