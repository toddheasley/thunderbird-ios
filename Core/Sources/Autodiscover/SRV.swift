import Foundation
import dnssd

/// Query DNS SRV records for available service connections.
///
/// Adapted from [archived `SRVResolver.swift`](https://github.com/jamf/NoMAD-2/blob/main/NoMAD/SRVLookups/SRVResolver.swift); added async/await query interface and configurable request timeout.
public class SRV {
    public struct Record: CustomStringConvertible, Equatable, Sendable {
        public let host: String
        public let port: Int
        public let priority: Int
        public let weight: Int

        init(_ data: Data) throws {
            guard data.count > 8, let host: String = String(bytes: data.suffix(from: 7), encoding: .utf8) else {
                throw URLError(.cannotDecodeRawData)
            }
            self.host = host.components(separatedBy: .controlCharacters).filter { !$0.isEmpty }.joined(separator: ".")
            port = (Int(data[4]) * 256) + Int(data[5])
            priority = (Int(data[0]) * 256) + Int(data[1])
            weight = (Int(data[2]) * 256) + Int(data[3])
        }

        // MARK: CustomStringConvertible
        public var description: String { "\(priority) \(weight) \(port) \(host)" }
    }

    public let timeoutInterval: TimeInterval

    public func query(_ query: String) async throws -> [Record] {
        try await withCheckedThrowingContinuation { continuation in
            self.query(query) { result in
                switch result {
                case .success(let records):
                    continuation.resume(returning: records)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public init(timeoutInterval: TimeInterval = 1.0) {
        self.timeoutInterval = timeoutInterval
    }

    private typealias Completion = (Result<[Record], Error>) -> Void

    private var completion: Completion?
    private var records: [Record] = []
    private var query: String?
    private var dispatchSourceRead: DispatchSourceRead?
    private var timeoutTimer: DispatchSourceTimer?
    private var serviceRef: DNSServiceRef?
    private var socket: dnssd_sock_t = -1

    private let queue: DispatchQueue = DispatchQueue(label: "SRV")
    private let callback: DNSServiceQueryRecordReply = { _, flags, _, _, _, _, _, rdlen, rdata, _, context in
        guard let context else { return }
        let srv: SRV = Unmanaged.fromOpaque(context).takeUnretainedValue()
        if let bytes = rdata?.assumingMemoryBound(to: UInt8.self),
            let record: Record = try? Record(Data(bytes: bytes, count: Int(rdlen)))
        {
            srv.records.append(record)
        }
        if (flags & kDNSServiceFlagsMoreComing) == 0 {
            srv.cancel()
            srv.completion?(.success(srv.records))
        }
    }

    private func query(_ query: String, completion: Completion? = nil) {
        self.completion = completion
        self.query = query

        let error: DNSServiceErrorType = DNSServiceQueryRecord(
            &serviceRef,
            kDNSServiceFlagsReturnIntermediates,
            UInt32(0),
            query.cString(using: .utf8),
            UInt16(kDNSServiceType_SRV),
            UInt16(kDNSServiceClass_IN),
            callback,
            Unmanaged.passUnretained(self).toOpaque()
        )
        switch error {
        case DNSServiceErrorType(kDNSServiceErr_NoError):
            guard let serviceRef else {
                fail()
                return
            }
            socket = DNSServiceRefSockFD(serviceRef)
            guard socket != -1 else {
                fail()
                return
            }
            dispatchSourceRead = DispatchSource.makeReadSource(fileDescriptor: socket, queue: queue)
            dispatchSourceRead?.setEventHandler {
                guard DNSServiceProcessResult(serviceRef) != kDNSServiceErr_NoError else { return }
                self.fail()
            }
            dispatchSourceRead?.setCancelHandler {
                DNSServiceRefDeallocate(serviceRef)
            }
            dispatchSourceRead?.resume()
            timeoutTimer = DispatchSource.makeTimerSource(flags: [], queue: queue)
            timeoutTimer?.setEventHandler {
                self.fail()
            }
            timeoutTimer?.schedule(deadline: .now() + timeoutInterval, repeating: .infinity, leeway: .never)
            timeoutTimer?.resume()
        default:
            fail()
        }
    }

    private func fail() {
        cancel()
        completion?(.failure(URLError(.cannotFindHost)))
    }

    private func cancel() {
        dispatchSourceRead?.cancel()
        timeoutTimer?.cancel()
    }
}
