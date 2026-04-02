import Foundation

extension URL {
    static func documents(_ path: String = "") -> Self {
        (isTestEnvironment ? Self.temporaryDirectory : .documentsDirectory).appending(path: path)
    }
}

extension ProcessInfo {
    var isTestEnvironment: Bool { environment["XCTestSessionIdentifier"] != nil }
}

var isTestEnvironment: Bool { ProcessInfo.processInfo.isTestEnvironment }
