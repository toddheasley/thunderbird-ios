import Foundation

public protocol Method: Identifiable {
    static var name: String { get }
    var accountID: String { get }
    var using: [Capability.Key] { get }
    var object: [Any] { get }

    // MARK: Identifiable
    var id: UUID { get }
}

extension Method {

    // MARK: Method
    public var using: [Capability.Key] { [.core, .mail] }
}

public struct MethodResponse: Identifiable {
    public let name: String
    public let data: Data
    public let notFound: [String]
    
    init(_ name: String, data: Data, notFound: [String], id: UUID) {
        self.name = name
        self.data = data
        self.notFound = notFound
        self.id = id
    }
    
    public func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        try JSONDecoder().decode(type, from: data)
    }
    
    // MARK: Identifiable
    public let id: UUID
}

public enum MethodError: String, CaseIterable, CustomStringConvertible, Decodable, Error, Identifiable {
    case accountNotFound, accountNotSupportedByMethod, accountReadOnly
    case forbidden
    case invalidArguments, invalidResultReference
    case serverFail, serverPartialFail, serverUnavailable
    case unknownMethod

    // MARK: CustomStringConvertible
    public var description: String { rawValue }

    // MARK: Decodable
    public init(from decoder: any Decoder) throws {
        var container: UnkeyedDecodingContainer = try decoder.unkeyedContainer()
        let _: String = try container.decode(String.self)
        let dictionary: [String: String] = try container.decode([String: String].self)
        guard let error: Self = Self(rawValue: dictionary["type"] ?? "") else {
            throw URLError(.cannotDecodeRawData)
        }
        self = error
    }

    // MARK: Identifiable
    public var id: String { rawValue }
}
