import ArgumentParser
import Foundation

@main
struct Main: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "Specify Weblate project name.")
    var name: String = "tb-android"

    @Option(name: .shortAndLong, help: "Set path to Xcode strings files.")
    var path: String?

    @Flag(name: .shortAndLong, help: "Remove Xcode strings for translations below completeness threshold.")
    var trim: Bool = false

    @Argument(help: "Override translation completeness threshold for trimming: 0...100%")
    var threshold: Double = 70.0  // Match existing Android threshold

    // MARK: AsyncParsableCommand
    static var configuration: CommandConfiguration {
        CommandConfiguration(abstract: "List language translations for a given Weblate project; remove Xcode strings for translations below a threshold of completeness.")
    }

    func run() async throws {
        print("Loading languages for Weblate project \"\(name)\"…")
        let languages: [Language] = try await URLSession.shared.languages(project: name)
        if trim {
            let urls: [URL] = try URL.strings(path: path)
            for url in urls {
                print(url)
            }
        }
        for language in languages {
            print(language)
        }
    }
}
