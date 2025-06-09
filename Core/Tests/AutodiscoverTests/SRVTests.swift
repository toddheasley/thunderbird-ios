import Testing
@testable import Autodiscover
import Foundation

struct SRVTests {
    @Test func query() async throws {

        // Thundermail
        #expect(try await SRV().query("_jmap._tcp.thundermail.com").first?.description == "0 1 443 mail.thundermail.com")
        #expect(try await SRV().query("_imaps._tcp.thundermail.com").first?.description == "0 1 993 mail.thundermail.com")
        #expect(try await SRV().query("_imap._tcp.thundermail.com").first?.description == "0 1 143 mail.thundermail.com")
        #expect(try await SRV().query("_submissions._tcp.thundermail.com").first?.description == "0 1 465 mail.thundermail.com")
        #expect(try await SRV().query("_submission._tcp.thundermail.com").first?.description == "0 1 587 mail.thundermail.com")
        #expect(try await SRV().query("_autodiscover._tcp.thundermail.com") == [])
        #expect(try await SRV().query("_pop3._tcp.thundermail.com") == [])

        // Fastmail
        #expect(try await SRV().query("_jmap._tcp.fastmail.com").first?.description == "0 1 443 api.fastmail.com")
        #expect(try await SRV().query("_autodiscover._tcp.fastmail.com").first?.description == "0 1 443 autodiscover.fastmail.com")
        #expect(try await SRV().query("_imaps._tcp.fastmail.com").first?.description == "0 1 993 imap.fastmail.com")
        #expect(try await SRV().query("_submissions._tcp.fastmail.com").first?.description == "0 1 465 smtp.fastmail.com")
        #expect(try await SRV().query("_pop3._tcp.fastmail.com") == [])
        #expect(try await SRV().query("_submission._tcp.fastmail.com") == [])

        // Gmail
        #expect(try await SRV().query("_imaps._tcp.gmail.com").first?.description == "5 0 993 imap.gmail.com")
        #expect(try await SRV().query("_submission._tcp.gmail.com").first?.description == "5 0 587 smtp.gmail.com")
        #expect(try await SRV().query("_autodiscover._tcp.gmail.com") == [])
        #expect(try await SRV().query("_jmap._tcp.gmail.com") == [])
        #expect(try await SRV().query("_pop3._tcp.gmail.com") == [])
    }
}
