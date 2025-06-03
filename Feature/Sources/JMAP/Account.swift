import Foundation

public struct Account: CustomStringConvertible, Decodable, Identifiable {
    public let name: String
    public let capabilities: [Capability.Key: Capability]
    public let isReadOnly: Bool
    public let isPersonal: Bool
    
    // MARK: Decodable
    public init(from decoder: any Decoder) throws {
        guard let id: String = decoder.id else {
            throw DecodingError.keyNotFound(Key.id, DecodingError.Context(codingPath: [Key.id], debugDescription: "Account ID not found"))
        }
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        name = try container.decode(String.self, forKey: .name)
        let dictionary: [String: Capability] = try container.decode([String: Capability].self, forKey: .accountCapabilities)
        var capabilities: [Capability.Key: Capability] = [:]
        for key in dictionary.keys {
            guard let _key: Capability.Key = Capability.Key(rawValue: key) else { continue }
            capabilities[_key] = dictionary[key]
        }
        self.capabilities = capabilities
        isReadOnly = try container.decode(Bool.self, forKey: .isReadOnly)
        isPersonal = try container.decode(Bool.self, forKey: .isPersonal)
        self.id = id
    }
    
    private enum Key: CodingKey {
        case name, accountCapabilities, isReadOnly, isPersonal, id
    }
    
    // MARK: CustomStringConvertible
    public var description: String { "" }
    
    // MARK: Identifiable
    public let id: String
}
