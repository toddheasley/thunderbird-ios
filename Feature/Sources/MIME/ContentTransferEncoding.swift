public enum ContentTransferEncoding: String, CaseIterable, CustomStringConvertible {
    case ascii = "7bit"
    case base64
    case binary
    case data = "8bit"
    case quotedPrintable = "quoted-printable"

    public static var `default`: Self { .ascii }

    // CustomStringConvertible
    public var description: String { rawValue }
}
