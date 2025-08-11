@testable import Account
import Testing
import Foundation

struct AccountTests {
    @Test func delete() throws {
        lock.lock()
        defer {
            lock.unlock()
        }
        Account.deleteAll()
        let accounts: [Account] = [
            Account(name: "Example 1"),
            Account(name: "Example 2"),
            Account(name: "Example 3")
        ]
        for account in accounts {
            try account.save()
        }
        #expect(Account.allCases.count == 3)
        try Account.allCases[1].delete()
        #expect(Account.allCases.count == 2)
        #expect(Account.allCases.first?.id == accounts[0].id)
        #expect(Account.allCases.last?.id == accounts[2].id)
        try Account.allCases.first?.delete()
        #expect(Account.allCases.count == 1)
        #expect(Account.allCases.first?.id == accounts[2].id)
        try Account.allCases.first?.delete()
        #expect(Account.allCases.count == 0)
    }

    @Test func save() throws {
        lock.lock()
        defer {
            lock.unlock()
        }
        Account.deleteAll()
        let accounts: [Account] = [
            Account(name: "Example 1"),
            Account(name: "Example 2"),
            Account(name: "Example 3")
        ]
        for account in accounts {
            try account.save()
        }
        #expect(Account.allCases.count == 3)
        #expect(Account.allCases.first?.id == accounts[0].id)
        #expect(Account.allCases.last?.id == accounts[2].id)
        try accounts[1].save(at: 0)
        #expect(Account.allCases.count == 3)
        #expect(Account.allCases.first?.id == accounts[1].id)
        #expect(Account.allCases.last?.id == accounts[2].id)
        try accounts[0].save(at: 100)
        #expect(Account.allCases.count == 3)
        #expect(Account.allCases.first?.id == accounts[1].id)
        #expect(Account.allCases.last?.id == accounts[0].id)
        Account.deleteAll()
    }
}

private let lock: NSLock = NSLock()
