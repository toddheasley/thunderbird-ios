import Foundation

extension FileManager {
    var accounts: [Account] {
        get throws {
            lock.lock()
            defer {
                lock.unlock()
            }
            guard fileExists(atPath: URL.accounts.path()) else { return [] }
            let data: Data = try Data(contentsOf: .accounts)
            return try JSONDecoder().decode([Account].self, from: data)
        }
    }
    
    func save(_ accounts: [Account]) throws {
        lock.lock()
        defer {
            lock.unlock()
        }
        let data: Data = try JSONEncoder().encode(accounts)
        if fileExists(atPath: URL.accounts.path()) {
            try removeItem(at: .accounts)
        }
        guard !accounts.isEmpty else { return }
        try data.write(to: .accounts)
    }
    
    func fileExists(at url: URL) throws -> Bool {
        guard url.isFileURL else {
            throw URLError(.unsupportedURL)
        }
        return fileExists(atPath: url.path())
    }
}

extension URL {
    static var accounts: Self { .documentsDirectory.appending(path: "Accounts.json") }
}

private let lock: NSLock = NSLock()
