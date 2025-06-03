import Foundation

extension JSONDecoder {
    static func jmap(id: String? = nil) -> JSONDecoder {  // https://jmap.io/spec-core.html#the-id-data-type
        let decoder: JSONDecoder = JSONDecoder(dateDecodingStrategy: .iso8601)
        if let id, !id.isEmpty {
            decoder.userInfo[.id] = id
        }
        return decoder
    }
    
    private convenience init(dateDecodingStrategy: DateDecodingStrategy) {
        self.init()
        self.dateDecodingStrategy = dateDecodingStrategy
    }
}

extension Decoder {
    var id: String? { userInfo[.id] as? String }  // https://jmap.io/spec-core.html#the-id-data-type
}

extension CodingUserInfoKey {
    static let id: Self = Self(rawValue: "id")!
}
