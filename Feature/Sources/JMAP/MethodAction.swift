public enum MethodAction: CustomStringConvertible {
    case create([String: Any])
    case update([String: Any])
    case destroy([String])

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .create: "create"
        case .update: "update"
        case .destroy: "destroy"
        }
    }
}
