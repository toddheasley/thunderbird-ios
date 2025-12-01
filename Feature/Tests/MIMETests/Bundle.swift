import Foundation

extension Bundle {
    func data(forResource name: String?, withExtension ext: String? = nil) -> Data? {
        guard let url: URL = Bundle.module.url(forResource: name, withExtension: ext) else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
