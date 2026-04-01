import Foundation

extension ProcessInfo {
    var isTestEnvironment: Bool { environment["XCTestSessionIdentifier"] != nil }
}

var isTestEnvironment: Bool { ProcessInfo.processInfo.isTestEnvironment }
