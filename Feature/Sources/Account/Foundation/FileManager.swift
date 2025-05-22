import Foundation

extension FileManager {
    func readAccounts(from url: URL) throws -> [Account]  {
        lock.lock()
        defer {
            lock.unlock()
        }
        guard try fileExists(at: url) else {
            throw URLError(.fileDoesNotExist)
        }
        let data: Data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Account].self, from: data)
    }
    
    func write(_ accounts: [Account], to url: URL) throws {
        lock.lock()
        defer {
            lock.unlock()
        }
        let data: Data = try JSONEncoder().encode(accounts)
        try? removeItem(at: url)
        guard !accounts.isEmpty else { return }
        try data.write(to: url)
    }

    func fileExists(at url: URL) throws -> Bool {
        guard url.isFileURL else {
            throw URLError(.unsupportedURL)
        }
        return fileExists(atPath: url.path())
    }
}

private let lock: NSLock = NSLock()
