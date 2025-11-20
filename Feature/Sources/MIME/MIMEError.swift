public enum MIMEError: Error, CustomStringConvertible, Equatable {
    case boundaryLength(Int)
    case boundaryNotASCII

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .boundaryLength(let length): "Multipart data boundary length \(length) outside of bounds \(Boundary.bounds)"
        case .boundaryNotASCII: "Multipart data boundary not ASCII"
        }
    }
}
