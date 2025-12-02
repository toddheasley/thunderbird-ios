/// Multipart email body must be ASCII in transfer. Parts encoded by this library use `base64` transfer encoding exclusively, but we expect to decode parts in any of the enumerated encodings, especially `quotedPrintable`.
public enum ContentTransferEncoding: String, CaseIterable, CustomStringConvertible, RawRepresentable {
    case ascii = "7bit"
    case base64
    case binary
    case data = "8bit"
    case quotedPrintable = "quoted-printable"

    public static var `default`: Self { .ascii }

    // CustomStringConvertible
    public var description: String { rawValue }
}
