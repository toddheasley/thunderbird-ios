import Foundation

extension URLSession {
    func languages(project slug: String, token: String? = nil) async throws -> [Language] {
        let data: Data = try await data(for: .languages(project: slug, token: token)).0
        return try JSONDecoder(.convertFromSnakeCase).decode([Language].self, from: data)
    }
}
