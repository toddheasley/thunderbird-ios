public enum ContentDisposition: String, CustomStringConvertible {
    case attachment, inline
    case extensionToken = "extension-token"

    // MARK: CustomStringConvertible
    public var description: String { rawValue }
}
