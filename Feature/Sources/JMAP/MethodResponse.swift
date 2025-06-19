import Foundation

public protocol MethodResponse: Identifiable {
    var name: String { get }
    var id: UUID { get }
}

public struct MethodGetResponse: MethodResponse {
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

    // MARK: MethodResponse
    public let name: String
    public let id: UUID
}

public struct MethodSetResponse: MethodResponse {
    public let created: [String: Any]
    public let updated: [String]
    public let destroyed: [String]
    public let notCreated: [String: SetError]
    public let notUpdated: [String: SetError]
    public let notDestroyed: [String: SetError]

    // MARK: MethodResponse
    public let name: String
    public let id: UUID
}
