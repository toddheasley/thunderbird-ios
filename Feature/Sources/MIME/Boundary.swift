import Foundation

/// Multipart data boundary described in [RFC 2046](https://www.rfc-editor.org/rfc/rfc2046)
public struct Boundary: CustomStringConvertible {
    public static var bounds: ClosedRange<Int> { 1...70 }

    /// Valid boundary is 1-70 characters US-ASCII, no trailing white space.
    public init(_ description: String = "") throws {
        let description: String = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let count: Int = description.count
        guard let data: Data = description.data(using: .ascii),
            let description: String = String(data: data, encoding: .ascii),
            description.count == count
        else {
            throw MIMEError.boundaryNotASCII
        }
        guard Self.bounds.contains(description.count) else {
            throw MIMEError.boundaryLength(description.count)
        }
        self.description = description
    }

    // MARK: CustomStringConvertible
    public let description: String
}
