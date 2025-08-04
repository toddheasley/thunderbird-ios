import ArgumentParser
import Cocoa

@main
struct Main: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "Specify Weblate project name.")
    var name: String = "tb-android"

    @Option(name: .shortAndLong, help: "Set path to Xcode strings files.")
    var path: String?  // Path must exist; nil path deep-searches user home directory for first localized Xcode project

    @Argument(help: "Override translation completeness threshold for trimming: 0-100%")
    var threshold: Double = 70.0  // Match existing Android threshold

    @Flag(name: .shortAndLong, help: "Remove Xcode strings for translations below completeness threshold.")
    var remove: Bool = false

    @Flag(name: .shortAndLong, help: "Open project strings localization folder in Finder.")
    var open: Bool = false

    // MARK: AsyncParsableCommand
    static var configuration: CommandConfiguration {
        CommandConfiguration(abstract: "List language translations for a given Weblate project; remove Xcode strings for translations below a threshold of completeness.")
    }

    func run() async throws {
        #if DEBUG
        print("DEBUG:")
        print("\(Bundle.main.executablePath!)")
        print("")
        #endif

        // Fetch language translations for named Weblate project
        print("Loading languages for Weblate project \(name)…")
        let languages: [Language] = try await URLSession.shared.languages(project: name)
        let published: [Language] = languages.filter { $0.isPublished(at: threshold) }
        print("")
        if !languages.isEmpty {

            // List language translations and current level of completeness
            print("LANGUAGES:")
            for language in languages {
                print(language, isPublished: language.isPublished(at: threshold))
            }

            // Summarize language translations
            print("")
            print("\(languages.count) language translations returned for Weblate project \(name).")
            print("\(published.count) language translations meet the threshold for completeness.")
        } else {
            print("No language translations returned for Weblate project \(name).")
        }
        print("")

        // Locate Xcode project localization on disk
        let identifiers: [String] = published.map { $0.identifier }
        var urls: [URL] = try URL.strings(path: path)
        guard let url: URL = urls.first?.deletingLastPathComponent() else {
            print("No existing Xcode project localization found.")
            return
        }
        print("Matching Xcode project localization found: \(url.path())")
        if remove {

            // Delete Xcode localizations for below-threshold translations
            print("Removing Xcode strings for translations below completeness threshold…")
            for url in urls {
                guard !identifiers.contains(url.deletingPathExtension().lastPathComponent) else { continue }
                try? FileManager.default.removeItem(at: url)
            }
            urls = try URL.strings(path: path)
        }

        // List currently configured Xcode localizations
        print("")
        print("LOCALIZATIONS:")
        for url in urls {
            print(url)
        }

        // Summarize Xcode project configuration
        print("")
        print("\(urls.count) localizations are configured in the Xcode project.")
        if open {
            print("Opening in Finder…")
            NSWorkspace.shared.open(url)
        }
        print("")
    }
}

private extension Language {

    // Xcode strings use Foundation Locale (hyphenated) identifier as file name
    var identifier: String { code.replacingOccurrences(of: "_", with: "-") }

    func isPublished(at threshold: Double = 0.0) -> Bool {
        translatedPercent >= threshold
    }
}

private func print(_ language: Language, isPublished: Bool = false) {
    print("\(isPublished ? "✓" : "-") \(language)")
}

private func print(_ url: URL) {
    print("\(url.path().dropLast())")
}
