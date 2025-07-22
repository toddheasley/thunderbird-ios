import ArgumentParser
import Foundation
import Weblate

@main
struct Main: AsyncParsableCommand {

    // MARK: ParsableCommand
    static var configuration: CommandConfiguration { CommandConfiguration(abstract: "Sync Weblate language translations") }

    func run() async throws {
        print("Loading languages…")
        let languages: [Language] = try await URLSession.shared.languages(project: "tb-android")
        if languages.isEmpty {
            print("Languages not found")
        } else {
            for language in languages {
                print("- \(language)")
            }
        }
    }
}
