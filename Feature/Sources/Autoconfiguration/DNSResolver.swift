@_exported import AsyncDNSResolver
import Foundation

public typealias DNSResolver = AsyncDNSResolver

extension DNSResolver {
    public static func querySRV(_ emailAddress: EmailAddress, services: [Service] = Service.allCases) async throws -> [SRVRecord] {
        var records: [SRVRecord] = []
        for service in services {
            records += try await querySRV(emailAddress, service: service)
        }
        return records
    }

    public static func querySRV(_ emailAddress: EmailAddress, service: Service) async throws -> [SRVRecord] {
        let name: String = try emailAddress.name(service)
        let records: [SRVRecord] = try await SRVResolver().query(name)
        return records
    }

    public static func queryMX(_ emailAddress: EmailAddress) async throws -> [MXRecord] {
        let host: String = try emailAddress.host
        let resolver: Self = try Self()
        let records: [MXRecord] = try await resolver.queryMX(name: host)
        return records
    }
}
