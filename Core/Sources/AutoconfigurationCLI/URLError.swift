import Foundation

extension URLError: @retroactive CustomStringConvertible {

    // MARK:  CustomStringConvertible
    public var description: String {
        switch code {
        case .fileDoesNotExist: "File not found"
        case .unsupportedURL: "Unsupported URL"
        case .notConnectedToInternet: "Not connected to internet"
        default: localizedDescription
        }
    }
}
