import Foundation

extension Locale {
    
    // https://jmap.io/spec-core.html#localisation-of-user-visible-strings
    static func acceptedLanguages() -> String {
        var languages: [String] = []
        for (index, language) in preferredLanguages.prefix(5).enumerated() {
            languages.append("\(language)\(index > 0 ? ";q=0.\(10 - index)" : "")")
        }
        languages.append("*;q=0.5")
        return languages.joined(separator: ", ")
    }
}
