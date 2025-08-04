import Foundation

struct Language: Decodable, CustomStringConvertible {
    let translatedPercent: Double  // 0.0...100.0
    let name: String
    let code: String  // Country code ("es") or ISO locale ("es-MX")
    let url: URL

    // MARK: CustomStringConvertible
    var description: String { "\(name) [\(code), \(translatedPercent)%]" }
}
