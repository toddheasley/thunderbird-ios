import Foundation

extension UUID {
    /// Generate a unique, MIME-compatible, US-ASCII data boundary
    public func dataBoundary(_ segments: Int = 5, separator: String = .separator, prefix: String? = nil, suffix: String? = nil) -> Boundary {
        try! Boundary("\(prefix?.ascii ?? "")\(uuidString(segments, separator: separator))\(suffix?.ascii ?? "")")
    }

    public func uuidString(_ segments: Int, separator: String = .separator) -> String {
        uuidString
            .components(separatedBy: String.separator)
            .prefix(max(segments, 1))
            .joined(separator: separator.ascii ?? .separator)
    }
}
