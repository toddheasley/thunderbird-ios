import ArgumentParser
import Autoconfiguration
import Foundation

@main
struct Autoconfig: AsyncParsableCommand {
    @Argument(help: "Specify email address to query.")
    var emailAddress: EmailAddress

    @Flag(name: .shortAndLong, help: "Save files to working directory.")
    var save: Bool = false

    @Flag(name: .shortAndLong, help: "Open URLs.")
    var open: Bool = false

    // MARK: AsyncParsableCommand
    func run() async throws {
        print("EMAIL ADDRESS: <\(emailAddress)>")
        print("")
        for source in Source.allCases {
            print("Querying the \(source) for \((try? emailAddress.host) ?? emailAddress)…")
            do {
                let autoconfig: (config: ClientConfig, data: (Data, Data)) = try await URLSession.shared.autoconfig(emailAddress, source: source)
                print("Configuration found for \(emailAddress):")
                print("")
                if let emailProvider: EmailProvider = autoconfig.config.emailProvider {
                    print("EMAIL PROVIDER:")
                    print("  Display name: \(emailProvider.displayName) (\(emailProvider.displayShortName))")
                    print("  Domain: \(emailProvider.domain)")
                    print("")
                    if !emailProvider.documentation.isEmpty {
                        print("  Documentation:")
                        for url in emailProvider.documentation {
                            print("    \(url.absoluteString)")
                        }
                        print("")
                    }
                    print("  Servers:")
                    for server in emailProvider.servers {
                        print("    [\(server.serverType)] \(server.hostname) \(server.port) \(server.socketType) \(server.authentication.joined(separator: "/"))")
                    }
                    print("")
                }
                if let oAuth2: OAuth2 = autoconfig.config.oAuth2 {
                    print("OAUTH2:")
                    print("  Issuer: \(oAuth2.issuer)")
                    print("  Scope: \(oAuth2.scope)")
                    print("")
                    print("  Auth URL:")
                    print("    \(oAuth2.authURL.absoluteString)")
                    print("")
                    print("  Token URL:")
                    print("    \(oAuth2.tokenURL.absoluteString)")
                    print("")
                }
                if let loginPage: URL = autoconfig.config.webMail?.loginPage {
                    print("WEB MAIL:")
                    print("  \(loginPage.absoluteString)")
                    print("")
                }
                if save {
                    try FileManager.default.save(emailAddress, data: autoconfig.data)
                }
                if open {
                    try? autoconfig.config.openWebMailLoginPage()
                    try? autoconfig.config.openDocumentation()
                }
            } catch {
                print((error as? URLError)?.description ?? error.localizedDescription)
                print("")
            }
            if open, save {
                Bundle.main.showExecutableInFinder()
            }
        }
    }
}
