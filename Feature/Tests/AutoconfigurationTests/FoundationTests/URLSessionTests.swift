@testable import Autoconfiguration
import Foundation
import Testing

struct URLSessionTests {
    @Test func sourcesAutoconfig() async throws {
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user.name@gmail.com", sources: [.provider, .wellKnown])
        }
        let gmail: (config: ClientConfig, source: Source) = try await URLSession.shared.autoconfig("user.name@gmail.com")
        #expect(gmail.config.emailProvider?.servers.count == 3)
        #expect(gmail.source == .ispDB)
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user@fastmail.com", sources: [.wellKnown, .ispDB])
        }
        let fastmail: (config: ClientConfig, source: Source) = try await URLSession.shared.autoconfig("user@fastmail.com")
        #expect(fastmail.config.emailProvider?.servers.count == 3)
        #expect(fastmail.source == .provider)
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user123@aol.com", sources: [.provider, .wellKnown])
        }
        let aol: (config: ClientConfig, source: Source) = try await URLSession.shared.autoconfig("user123@aol.com")
        #expect(aol.config.emailProvider?.servers.count == 3)
        #expect(aol.source == .ispDB)
    }

    @Test func sourceAutoconfig() async throws {
        let gmail: ClientConfig = try await URLSession.shared.autoconfig("user.name@gmail.com", source: .ispDB).config
        #expect(gmail.emailProvider?.displayName == "Google Mail")
        #expect(gmail.emailProvider?.displayShortName == "GMail")
        #expect(gmail.emailProvider?.documentation.count == 4)
        #expect(gmail.emailProvider?.domain == "gmail.com")
        #expect(gmail.emailProvider?.servers.count == 3)
        #expect(
            gmail.emailProvider?.servers.first?.authentication == [
                .oAuth2,
                .passwordCleartext
            ])
        #expect(gmail.emailProvider?.servers.first?.hostname == "imap.gmail.com")
        #expect(gmail.emailProvider?.servers.first?.port == 993)
        #expect(gmail.emailProvider?.servers.first?.serverType == .imap)
        #expect(gmail.emailProvider?.servers.first?.socketType == .ssl)
        #expect(gmail.emailProvider?.servers.first?.username == "user.name@gmail.com")
        #expect(gmail.webMail?.loginPage.absoluteString == "https://accounts.google.com/ServiceLogin?service=mail&continue=http://mail.google.com/mail/")
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user.name@gmail.com", source: .provider)
        }
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user.name@gmail.com", source: .wellKnown)
        }

        let fastmail: ClientConfig = try await URLSession.shared.autoconfig("user@fastmail.com", source: .provider).config
        #expect(fastmail.emailProvider?.displayName == "Fastmail")
        #expect(fastmail.emailProvider?.displayShortName == "Fastmail")
        #expect(fastmail.emailProvider?.documentation.count == 2)
        #expect(fastmail.emailProvider?.domain == "fastmail.com")
        #expect(fastmail.emailProvider?.servers.count == 3)
        #expect(
            fastmail.emailProvider?.servers.first?.authentication == [
                .oAuth2
            ])
        #expect(fastmail.emailProvider?.servers.first?.hostname == "imap.fastmail.com")
        #expect(fastmail.emailProvider?.servers.first?.port == 993)
        #expect(fastmail.emailProvider?.servers.first?.serverType == .imap)
        #expect(fastmail.emailProvider?.servers.first?.socketType == .ssl)
        #expect(fastmail.emailProvider?.servers.first?.username == "user@fastmail.com")
        #expect(fastmail.webMail?.loginPage.absoluteString == "https://app.fastmail.com/login/?domain=fastmail.com")
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user@fastmail.com", source: .wellKnown)
        }
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user@fastmail.com", source: .ispDB)
        }

        let aol: ClientConfig = try await URLSession.shared.autoconfig("user123@aol.com", source: .ispDB).config
        #expect(aol.emailProvider?.displayName == "AOL Mail")
        #expect(aol.emailProvider?.displayShortName == "AOL")
        #expect(aol.emailProvider?.documentation.count == 1)
        #expect(aol.emailProvider?.domain == "aol.com")
        #expect(aol.emailProvider?.servers.count == 3)
        #expect(
            aol.emailProvider?.servers.first?.authentication == [
                .oAuth2,
                .passwordCleartext
            ])
        #expect(aol.emailProvider?.servers.first?.hostname == "imap.aol.com")
        #expect(aol.emailProvider?.servers.first?.port == 993)
        #expect(aol.emailProvider?.servers.first?.serverType == .imap)
        #expect(aol.emailProvider?.servers.first?.socketType == .ssl)
        #expect(aol.emailProvider?.servers.first?.username == "user123@aol.com")
        #expect(aol.webMail?.loginPage.absoluteString == "https://mail.aol.com/")
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user123@aol.com", source: .provider)
        }
        await #expect(throws: URLError.self) {
            try await URLSession.shared.autoconfig("user123@aol.com", source: .wellKnown)
        }
    }
}
