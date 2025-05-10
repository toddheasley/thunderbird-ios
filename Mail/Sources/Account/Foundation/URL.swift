import Foundation

extension URL {
    public static var accounts: Self { documents("Accounts.json") }
    
    static func documents(_ path: String = "") -> Self {
        
        // Use temporary directory in test environment
        (isTestEnvironment ? Self.temporaryDirectory : .documentsDirectory).appending(path: path)
    }
}

private var isTestEnvironment: Bool { ProcessInfo.processInfo.environment["XCTestSessionIdentifier"] != nil }
