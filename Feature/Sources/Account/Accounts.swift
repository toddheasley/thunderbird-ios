import Foundation

@Observable
public class Accounts {
    public private(set) var allAccounts: [Account] = []
    public private(set) var error: Error?

    public func set(_ account: Account, at index: Int? = nil) {
        error = nil
        do {
            var accounts: [Account] = allAccounts
            let currentIndex: Int? = accounts.firstIndex { account.id == $0.id }
            if let currentIndex {
                accounts.remove(at: currentIndex)
            }
            let index: Int? = index ?? currentIndex  // New index OR current index OR nil (append to end)
            if let index, index < accounts.count {
                accounts.insert(account, at: index)  // Insert at new or current target index
            } else {
                accounts.append(account)  // Append to end of array
            }
            try FileManager.default.write(accounts, to: .accounts)
            allAccounts = try FileManager.default.readAccounts(from: .accounts)
        } catch {
            self.error = error
        }
    }

    public func delete(_ account: Account) {
        error = nil
        do {
            try FileManager.default.write(allAccounts.filter { $0.id != account.id }, to: .accounts)
            allAccounts = try FileManager.default.readAccounts(from: .accounts)
        } catch {
            self.error = error
        }
    }

    public func deleteAccounts() {
        error = nil
        do {
            try FileManager.default.write([], to: .accounts)
            allAccounts = []
        } catch {
            self.error = error
        }
    }

    public init() {
        do {
            guard try FileManager.default.fileExists(at: .accounts) else { return }
            allAccounts = try FileManager.default.readAccounts(from: .accounts)
        } catch {
            self.error = error
        }
    }
}

private extension URL {
    static var accounts: Self { documents("Accounts.json") }
}
