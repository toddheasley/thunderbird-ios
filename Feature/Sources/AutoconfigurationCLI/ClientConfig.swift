import Autoconfiguration
#if canImport(Cocoa)
import Cocoa
#endif
import Foundation

extension ClientConfig {
    func openDocumentation() throws {
        guard let urls: [URL] = emailProvider?.documentation else {
            throw URLError(.resourceUnavailable)
        }
        for url in urls {
            open(url)
        }
    }

    func openWebMailLoginPage() throws {
        guard let url: URL = webMail?.loginPage else {
            throw URLError(.resourceUnavailable)
        }
        open(url)
    }
}

// swift-format-ignore
private func open(_ url: URL) {
#if canImport(Cocoa)
    NSWorkspace.shared.open(url)
#endif
}
