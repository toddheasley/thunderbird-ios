public enum ContentDisposition: String, CaseIterable, CustomStringConvertible {
    case attachment
    case extensionToken = "extension-token"
    case inline

    // MARK: CustomStringConvertible
    public var description: String { rawValue }
}
