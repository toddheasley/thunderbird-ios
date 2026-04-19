import Foundation

public enum TestResult: CustomStringConvertible, Identifiable, Sendable {
    case imapConnect(Error? = nil)
    case imapAuthenticate(Error? = nil)
    case imapCapability(IMAP.Capability)
    case jmapSession(Error? = nil)
    case jmapCapability(JMAP.Capability, key: JMAP.Capability.Key)
    case smtpSend(Error? = nil)

    public var isFailure: Bool { error != nil }

    public var error: Error? {
        switch self {
        case .imapConnect(let error),
            .imapAuthenticate(let error),
            .jmapSession(let error),
            .smtpSend(let error):
            error
        default: nil
        }
    }

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .imapConnect: "IMAP CONNECT"
        case .imapAuthenticate: "IMAP AUTHENTICATE"
        case .imapCapability(let capability): "IMAP: \(capability)"
        case .jmapSession: "JMAP SESSION"
        case .jmapCapability(_, let key): "JMAP \(key.description.uppercased())"
        case .smtpSend: "SMTP SEND"
        }
    }

    // MARK: Identifiable
    public var id: String { description }
}

extension Account {
    /// Run basic validations for both IMAP/SMTP and JMAP `Account` configurations.
    @MainActor
    public func test(sleep duration: Duration = .milliseconds(100)) -> AsyncStream<TestResult> {
        let account: Self = self
        return AsyncStream { continuation in
            Task {
                switch account.emailProtocol {
                case .imap:
                    var result: TestResult = .imapConnect()
                    do {
                        guard let incomingServer: Server = account.incomingServer else {
                            throw IMAPError.serverProtocolMismatch
                        }
                        let client: IMAPClient = IMAPClient(try IMAP.Server(incomingServer))
                        try await client.connect()
                        continuation.yield(.imapConnect())
                        result = .imapAuthenticate()
                        try await client.login()
                        continuation.yield(.imapAuthenticate())
                        for capability in client.capabilities {
                            try await Task.sleep(for: duration)  // Just for drama
                            continuation.yield(.imapCapability(capability))
                        }
                        try await client.logout()
                        result = .smtpSend()
                        guard let outgoingServer: Server = account.outgoingServer else {
                            throw SMTPError.serverProtocolMismatch
                        }
                        let _: SMTPClient = SMTPClient(try SMTP.Server(outgoingServer))
                        continuation.yield(.smtpSend())
                    } catch {
                        switch result {
                        case .imapAuthenticate: continuation.yield(.imapAuthenticate(error))
                        case .smtpSend: continuation.yield(.smtpSend(error))
                        default: continuation.yield(.imapConnect(error))
                        }
                    }
                case .jmap:
                    do {
                        guard let server: Server = account.servers.first else {
                            throw JMAPError.serverProtocolMismatch
                        }
                        let client: JMAPClient = try await .session(try JMAP.Server(server))
                        guard let session: Session = client.session else {
                            throw JMAPError.sessionNotFound
                        }
                        continuation.yield(.jmapSession())
                        for capability in session.capabilities.sorted(by: { $0.0.rawValue < $1.0.rawValue }) {
                            try await Task.sleep(for: duration)  // Just for drama
                            continuation.yield(.jmapCapability(capability.value, key: capability.key))
                        }
                    } catch {
                        continuation.yield(.jmapSession(error))
                    }
                }
                continuation.finish()
            }
        }
    }
}
