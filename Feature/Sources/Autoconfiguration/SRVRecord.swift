import AsyncDNSResolver
import Foundation

extension SRVRecord {
    init(_ data: Data) throws {
        guard data.count > 8, var host: String = String(bytes: data.suffix(from: 7), encoding: .utf8) else {
            throw URLError(.cannotDecodeRawData)
        }
        host = host.components(separatedBy: .controlCharacters).filter { !$0.isEmpty }.joined(separator: ".")
        let port: UInt16 = (UInt16(data[4]) * 256) + UInt16(data[5])
        let priority: UInt16 = (UInt16(data[0]) * 256) + UInt16(data[1])
        let weight: UInt16 = (UInt16(data[2]) * 256) + UInt16(data[3])
        self.init(host: host, port: port, weight: weight, priority: priority)
    }
}
