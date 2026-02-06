import Foundation
import NIOIMAPCore

public typealias UID = NIOIMAPCore.UID

public struct Message {
    public enum Component: CustomStringConvertible, Equatable, Identifiable, Sendable {
        case bodyPart(SectionSpecifier, Data)
        case bodyStructure(BodyStructure, _ hasExtensionData: Bool = false)
        case emailID(String)
        case envelope(Envelope)
        case flags(Set<Flag>)
        case gmailLabels([GmailLabel])
        case gmailMessageID(UInt64)
        case gmailThreadID(UInt64)
        case internalDate(Date)
        case threadID(String)
        case uid(UID)

        public typealias BodyStructure = NIOIMAPCore.MessageAttribute.BodyStructure
        public typealias SectionSpecifier = NIOIMAPCore.SectionSpecifier

        // MARK: Equatable
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }

        // MARK: Identifiable
        public var id: String {
            switch self {
            case .bodyPart(let section, _): "bodyPart: \(section)"
            case .bodyStructure: "bodyStructure"
            case .emailID: "emailID"
            case .envelope: "envelope"
            case .flags: "flags"
            case .gmailLabels: "gmailLabels"
            case .gmailMessageID: "gmailMessageID"
            case .gmailThreadID: "gmailThreadID"
            case .internalDate: "internalDate"
            case .threadID: "threadID"
            case .uid: "uid"
            }
        }

        // MARK: CustomStringConvertible
        public var description: String {
            switch self {
            case .bodyPart(_, let data): "\(id) (\(data))"
            case .bodyStructure(let structure, let hasExtensionsData): "\(id): \(structure)\(hasExtensionsData ? " (hasExtensionsData)" : "")"
            case .emailID(let id), .threadID(let id): "\(self.id): \(id)"
            case .envelope(let envelope): "\(id): \(envelope)"
            case .flags(let flags): "\(id): \(flags)"
            case .gmailLabels(let labels): "\(id): \(labels)"
            case .gmailMessageID(let id), .gmailThreadID(let id): "\(self.id): \(id)"
            case .internalDate(let date): "\(id): \(date)"
            case .uid(let uid): "\(id): \(uid)"
            }
        }
    }

    public let components: [Component]

    public init(components: [Component]) {
        self.components = components
    }
}
