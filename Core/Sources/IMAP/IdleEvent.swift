/// Updates to selected ``Mailbox`` during ``IMAPClient`` idle
public enum IdleEvent: Sendable {

    /// IMAP ``Server`` disconnected during idle
    case bye(String?)

    ///  ``Message`` deleted from selected ``Mailbox`` during idle
    case expunge(SequenceNumber)

    /// Fetched updates to a specific ``Message``,  collected as ``Message.Component``
    case fetch(SequenceNumber, [Message.Component])

    /// Message count changed for selected ``Mailbox``
    case status(Mailbox.Status)
}
