import Foundation

extension URL {
    static func languages(project name: String) throws -> Self {
        guard !name.isEmpty else {
            throw URLError(.badURL)
        }
        return Self(string: "https://hosted.weblate.org/api/projects/\(name)/languages/")!
    }

    static func strings(path: String? = nil) throws -> [Self] {

        // List all strings files in Xcode project strings directory
        var isDirectory: ObjCBool = false
        guard let path: String = path ?? stringsDirectory?.path(),  // Fall back to "magic" strings URL
            FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory),
            isDirectory.boolValue
        else {
            throw URLError(.fileDoesNotExist)
        }
        let strings: [Self] = try FileManager.default.contentsOfDirectory(
            at: Self(fileURLWithPath: path),
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        ).filter {
            $0.lastPathComponent.hasSuffix(".lproj")
        }
        return strings
    }

    private static var stringsDirectory: Self? {

        // Search from documents first, then search from entire home directory
        stringsDirectory(from: .documentsDirectory) ?? stringsDirectory(from: .homeDirectory)
    }

    private static func stringsDirectory(from directory: URL) -> Self? {

        // Recursively search from directory for (first occurrence of) localization path
        let enumerator: FileManager.DirectoryEnumerator = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: .skipsHiddenFiles
        )!
        while let url: URL = enumerator.nextObject() as? URL {
            guard url.path().hasSuffix("/Thunderbird/Thunderbird/Localization/") else {
                continue
            }
            return url
        }
        return nil
    }
}
