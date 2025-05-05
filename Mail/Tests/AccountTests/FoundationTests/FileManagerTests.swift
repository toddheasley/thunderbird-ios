import Testing
import Foundation
@testable import Account

struct FileManagerTests {
    @Test func saveAccounts() throws {
        let accounts: [Account] = [
            Account(name: "Test 1"),
            Account(name: "Test 2"),
            Account(name: "Test 3")
        ]
        try FileManager.default.save(accounts)
        #expect(try FileManager.default.accounts.count == 3)
        #expect(try FileManager.default.accounts[0].id == accounts[0].id)
        #expect(try FileManager.default.accounts[1].id == accounts[1].id)
        #expect(try FileManager.default.accounts[2].id == accounts[2].id)
        try FileManager.default.save([
            accounts[2],
            accounts[1]
        ])
        #expect(try FileManager.default.accounts.count == 2)
        #expect(try FileManager.default.accounts[0].id == accounts[2].id)
        #expect(try FileManager.default.accounts[1].id == accounts[1].id)
        try FileManager.default.save([])
        #expect(try FileManager.default.accounts.count == 0)
        #expect(try FileManager.default.fileExists(at: .accounts) == false)
    }
    
    @Test func fileExists() throws {
        let url: URL = .temporaryDirectory.appending(path: "Test.txt")
        let data: Data = "Test".data(using: .utf8)!
        try data.write(to: url)
        #expect(try FileManager.default.fileExists(at: url) == true)
        #expect(String(data: try Data(contentsOf: url), encoding: .utf8) == "Test")
        try? FileManager.default.removeItem(at: url)
        #expect(try FileManager.default.fileExists(at: url) == false)
    }
}
