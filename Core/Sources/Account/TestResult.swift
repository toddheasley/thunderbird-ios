import Foundation

extension Account {
    /// Run basic validations for both IMAP/SMTP and JMAP `Account` configurations.
    ///
    /// Sleep duration clamps stream to a minimum delay between posted test results, useful for buffering UI updates.
    @MainActor
    public func test(sleep duration: Duration = .milliseconds(20)) -> AsyncStream<TestResult> {
        let account: Self = self
        return AsyncStream { continuation in
            Task {
                switch account.emailProtocol {
                case .imap:
                    var description: String = "IMAP CONNECT"
                    do {
                        guard let incomingServer: Server = account.incomingServer else {
                            throw IMAPError.serverProtocolMismatch
                        }
                        let client: IMAPClient = IMAPClient(try IMAP.Server(incomingServer))
                        try await client.connect()
                        continuation.yield(.success(description))
                        description = "IMAP AUTHENTICATE"
                        try await client.login()
                        continuation.yield(.success(description))
                        for capability in client.capabilities {
                            try await Task.sleep(for: duration)  // Buffer yield, just for drama
                            continuation.yield(.success("IMAP \(capability)"))
                        }
                        try await client.logout()
                        description = "SMTP SEND"
                        guard let outgoingServer: Server = account.outgoingServer else {
                            throw SMTPError.serverProtocolMismatch
                        }
                        let _: SMTPClient = SMTPClient(try SMTP.Server(outgoingServer))
                        continuation.yield(.success(description))
                    } catch {
                        continuation.yield(.failure(description, error: error))
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
                        continuation.yield(.success("JMAP SESSION"))
                        for capability in session.capabilities.sorted(by: { $0.0.rawValue < $1.0.rawValue }) {
                            try await Task.sleep(for: duration)  // Buffer yield, just for drama
                            continuation.yield(.success("JMAP \(capability.key.description.uppercased())"))
                        }
                    } catch {
                        continuation.yield(.failure("JMAP SESSION", error: error))
                    }
                }
                continuation.finish()
            }
        }
    }
}

public enum TestResult: CustomStringConvertible, Identifiable, Sendable {
    case failure(String, error: Error)
    case success(String)

    public var isFailure: Bool { error != nil }

    public var error: Error? {
        switch self {
        case .failure(_, let error): error
        case .success: nil
        }
    }

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .failure(let description, _), .success(let description): description
        }
    }

    // MARK: Identifiable
    public var id: String {
        switch self {
        case .failure(let string, _): "\(string):x"
        case .success(let string): string
        }
    }
}
