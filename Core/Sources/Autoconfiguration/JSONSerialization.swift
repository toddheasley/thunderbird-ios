import Foundation

extension JSONSerialization {
    static func data(_ dictionary: [String: Any], options: WritingOptions = .withoutEscapingSlashes) throws -> Data {
        let data: Data = try data(withJSONObject: dictionary, options: options)
        return String(data: data, encoding: .utf8)!.replacingOccurrences(of: " : ", with: ": ").data(using: .utf8)!  // Fix bad pretty-print formatting
    }
}
