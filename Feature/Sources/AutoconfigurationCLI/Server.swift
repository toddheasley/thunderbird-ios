import Autoconfiguration

extension [Server.Authentication] {
    func joined(separator: String = "") -> String {
        map { $0.description }.joined(separator: separator)
    }
}
