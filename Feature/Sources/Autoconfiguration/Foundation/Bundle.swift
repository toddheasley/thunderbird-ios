import Foundation

extension Bundle {
    /// Read custom URL schemes declared in Info.plist
    public var schemes: [String] {
        guard let bundleURLType: [String: Any] = (object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]])?.first else {
            return []
        }
        return bundleURLType["CFBundleURLSchemes"] as? [String] ?? []
    }
}
