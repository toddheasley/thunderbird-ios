@testable import Autoconfiguration
import Testing
import Foundation

struct URLSessionTests {
    @Test func sourcesAutoconfig() async throws {

    }
    
    @Test func sourceAutoconfig() async throws {
        /*
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user.name@gmail.com", source: .provider)
        }
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user.name@gmail.com", source: .wellKnown)
        }
        let string: String = try await URLSession.shared.autoconfig("user.name@gmail.com", source: .ispDB)
        print(string) */

        /*
        let string: String = try await URLSession.shared.autoconfig("user@fastmail.com", source: .provider)
        print(string)
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user@fastmail.com", source: .wellKnown)
        }
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user@fastmail.com", source: .ispDB)
        } */

        /*
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user123@aol.com", source: .provider)
        }
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user123@aol.com", source: .wellKnown)
        }
        let string: String = try await URLSession.shared.autoconfig("user123@aol.com", source: .ispDB)
        print(string) */
    }
}
