import Foundation

extension URL {
    static func languages(project slug: String) -> Self {
        Self(string: "https://hosted.weblate.org/api/projects/\(slug)/languages/")!
    }
}
