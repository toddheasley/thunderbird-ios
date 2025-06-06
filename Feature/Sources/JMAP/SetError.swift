public enum SetError: String, CaseIterable, CustomStringConvertible, Decodable, Error, Identifiable {
    case forbidden
    case invalidPatch, invalidProperties
    case notFound
    case overQuota
    case rateLimit
    case requestTooLarge
    case singleton
    case stateMismatch
    case tooLarge
    case willDestroy
    
    // MARK: CustomStringConvertible
    public var description: String { rawValue }
    
    
    // MARK: Decodable
    public init(from decoder: any Decoder) throws {
        fatalError("init(from decoder:) has not been implemented")
        
        // Spec doesn't really explain this error type -- or what the JSON might look like.
        // TODO: Implement with real JSON when implementing section 5 (methods).
    }
    
    // MARK: Identifiable
    public var id: String { rawValue }
}
