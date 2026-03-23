import Foundation

extension Bundle {
    func data(forResource name: String?, withExtension ext: String? = nil) throws -> Data {
        guard let url: URL = url(forResource: name, withExtension: ext) else {
            throw URLError(.fileDoesNotExist)
        }
        return try Data(contentsOf: url)
    }
}
