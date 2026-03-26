import Foundation
@testable import IMAP
import MIME
import Testing

struct IMAPClientTests {
    @Test(arguments: Server.allCases(disabled: false)) func allCommands(_ server: Server) async throws {
        let client: IMAPClient = IMAPClient(server)
        try await client.connect()
        try await client.login()  // Use credentials in canned `Server`

        let mailboxes: [Mailbox] = try await client.list()  // List mailboxes
        guard let inbox: Mailbox = mailboxes.filter({ $0.path.name.isInbox }).first else {
            throw IMAPError.unexpectedResponse("Inbox not found")
        }  // Find inbox in mailbox list
        try await client.select(mailbox: inbox)  // Select inbox

        let status = try await client.status(mailbox: inbox)
        #expect(status.messageCount != nil && status.messageCount! > 0)
        #expect(status.recentCount != nil && status.recentCount! >= 0)
        #expect(status.unseenCount != nil && status.unseenCount! >= 0)

        // Fetch all inbox messages w/ all attributes
        let messages: [SequenceNumber: Message] = try await client.fetch(attributes: [
            .bodySection(peek: true, .header, nil),
            .bodyStructure(extensions: true),
            .emailID,
            .envelope,
            .flags,
            .gmailLabels,
            .gmailMessageID,
            .gmailThreadID,
            .internalDate,
            .preview(lazy: false),
            .threadID,
            .uid
        ])
        #expect(messages.count > 0)
        for sequenceNumber in messages.keys.sorted().reversed() {
            let message: Message = messages[sequenceNumber]!
            for component in message.components {
                switch component {
                case .envelope(let envelope):
                    #expect(!envelope.from.isEmpty == true)
                    #expect(!envelope.to.isEmpty == true)
                default: break
                }
            }
        }

        let mailbox: Mailbox.Name = Mailbox.Name(UUID().uuidString(2, separator: " "))  // Unique mailbox name w/ space
        let renamed: Mailbox.Name = Mailbox.Name(UUID().uuidString(1))
        try await client.create(mailbox: mailbox)
        try await client.subscribe(mailbox: mailbox)
        try await client.rename(mailbox: mailbox, to: renamed)
        try await client.unsubscribe(mailbox: renamed)  // Renamed mailbox should retain subscription
        try await client.delete(mailbox: renamed)

        do {
            try client.isSupported(.idle)
            try await client.idle()
            try await Task.sleep(for: .seconds(5.0))  // Idle
            try await client.done()
        } catch {
            print(error)
        }

        try await client.logout()
        try? client.disconnect()
    }
}
