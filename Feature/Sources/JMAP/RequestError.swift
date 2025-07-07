/// Request-level configuration errors, part of [JMAP core](https://jmap.io/spec-core.html#errors)
public struct RequestError: Error, Decodable, CustomStringConvertible {
    public enum Code: String, CaseIterable, Codable, CustomStringConvertible, Identifiable, Sendable {
        case limit = "urn:ietf:params:jmap:error:limit"
        case notJSON = "urn:ietf:params:jmap:error:notJSON"
        case notRequest = "urn:ietf:params:jmap:error:notRequest"
        case unknownCapability = "urn:ietf:params:jmap:error:unknownCapability"

        // MARK: CustomStringConvertible
        public var description: String { rawValue.components(separatedBy: ":").last! }

        // MARK: Identifiable
        public var id: String { rawValue }
    }

    public let code: Code

    // MARK: Decodable
    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        code = try container.decode(Code.self, forKey: .type)
        description = try container.decode(String.self, forKey: .detail)
    }

    private enum Key: CodingKey {
        case `type`, detail
    }

    // MARK: CustomStringConvertible
    public let description: String
}
