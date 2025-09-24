import Foundation

extension URL {
    static func documents(_ path: String = "") -> Self {
        (isTestEnvironment ? Self.temporaryDirectory : .documentsDirectory).appending(path: path)
    }
}
