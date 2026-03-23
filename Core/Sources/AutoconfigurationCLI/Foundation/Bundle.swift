#if canImport(Cocoa)
import Cocoa
#endif
import Foundation

// swift-format-ignore
extension Bundle {
    var executableDirectory: URL { executableURL!.deletingLastPathComponent() }

    func showExecutableInFinder() {
#if canImport(Cocoa)
        NSWorkspace.shared.open(executableDirectory)
#endif
    }
}
