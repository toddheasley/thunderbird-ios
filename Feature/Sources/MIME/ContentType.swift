import Foundation

/// [Media content types](https://www.iana.org/assignments/media-types/media-types.xhtml) with base types enumerated
public enum ContentType: CustomStringConvertible, Equatable, RawRepresentable {
    case application(String)
    case audio(String)
    case example(String)
    case font(String)
    case haptics(String)
    case image(String)
    case message(String)
    case model(String)
    case multipart(String)
    case text(String)
    case video(String)

    public var subType: String {
        switch self {
        case .application(let subType),
            .audio(let subType),
            .example(let subType),
            .font(let subType),
            .haptics(let subType),
            .image(let subType),
            .message(let subType),
            .model(let subType),
            .multipart(let subType),
            .text(let subType),
            .video(let subType):
            subType
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
    public var rawValue: String { "\(value)/\(subType)" }

    public init?(rawValue: String) {
        guard let data: Data = rawValue.trimmingCharacters(in: .whitespacesAndNewlines).data(using: .ascii),
            let rawValue: [String] = String(data: data, encoding: .ascii)?.components(separatedBy: "/"),
            rawValue.count == 2, rawValue[1].count > 1
        else {
            return nil
        }
        let subType: String = rawValue[1]
        switch rawValue[0].lowercased() {
        case "application":
            self = .application(subType)
        case "audio":
            self = .audio(subType)
        case "example":
            self = .example(subType)
        case "font":
            self = .font(subType)
        case "haptics":
            self = .haptics(subType)
        case "image":
            self = .image(subType)
        case "message":
            self = .message(subType)
        case "model":
            self = .model(subType)
        case "multipart":
            self = .multipart(subType)
        case "text":
            self = .text(subType)
        case "video":
            self = .video(subType)
        default:
            return nil
        }
    }
}

extension ContentType {
    public static var multipartAlternative: Self { .multipart(.alternative) }
    public static var multipartMixed: Self { .multipart(.mixed) }
    public static var multipartRelated: Self { .multipart(.related) }
}

extension String {
    static var alternative: Self { "alternative" }
    static var mixed: Self { "mixed" }
    static var related: Self { "related" }
}
