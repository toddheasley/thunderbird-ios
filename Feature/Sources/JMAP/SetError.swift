/// Errors encountered during a `set` ``Method`` operation, returned exclusively in ``MethodResponse``
public enum SetError: String, CaseIterable, CustomStringConvertible, Error, Identifiable {
    case forbidden
    case invalidPatch, invalidProperties
    case mailboxHasEmail
    case notFound
    case overQuota
    case rateLimit
    case requestTooLarge
    case singleton
    case stateMismatch
    case tooLarge
    case willDestroy

    /// Decode from ``MethodResponse`` dictionary or string
    init?(_ value: Any) {
        if let value: [String: Any] = value as? [String: Any],
            let error: Self = Self(rawValue: value["type"] as? String ?? "")
        {
            self = error
        } else if let error: Self = Self(rawValue: value as? String ?? "") {
            self = error
        } else {
            return nil
        }
    }

    // MARK: CustomStringConvertible
    public var description: String { rawValue }

    // MARK: Identifiable
    public var id: String { rawValue }
}
