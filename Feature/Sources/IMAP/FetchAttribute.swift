import NIOIMAPCore

public typealias FetchAttribute = NIOIMAPCore.FetchAttribute

extension [FetchAttribute] {
    static func extended(_ capabilities: Set<Capability>) -> Self {
        Array(Set(capabilities.flatMap { extended($0) }))
    }

    static func extended(_ capability: Capability) -> Self {
        switch capability {
        case .gmailExtensions:
            [
                .gmailLabels,
                .gmailMessageID,
                .gmailThreadID
            ]
        case .objectID:
            [
                .emailID,
                .threadID
            ]
        case .preview:
            [
                .preview(lazy: true)
            ]
        default: []
        }
    }

    static var standard: Self {
        [
            .envelope,
            .flags,
            .uid
        ]
    }

    func filtered(_ capabilities: Set<Capability>) -> Self {
        filter { attribute in
            switch attribute {
            case .emailID, .threadID: capabilities.contains(.objectID)
            case .gmailLabels, .gmailMessageID, .gmailThreadID: capabilities.contains(.gmailExtensions)
            case .preview: capabilities.contains(.preview)
            default: true
            }
        }
    }
}
