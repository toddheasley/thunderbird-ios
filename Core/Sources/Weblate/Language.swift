import Foundation

public struct Language: Decodable, CustomStringConvertible {
    public let translatedPercent: Double  // 0.0...100.0
    public let name: String
    public let code: String  // Country code ("es") or ISO locale ("es-MX")
    public let url: URL

    // MARK: CustomStringConvertible
    public var description: String { "\(name) (\(code), \(translatedPercent)%)" }
}
