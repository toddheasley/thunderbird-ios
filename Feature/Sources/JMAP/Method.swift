import Foundation

/// Standard request object, part of [JMAP core](https://jmap.io/spec-core.html#the-request-object)
public protocol Method: Identifiable {
    static var name: String { get }
    var accountID: String { get }
    var using: [Capability.Key] { get }
    var object: [Any] { get }

    // MARK: Identifiable
    var id: UUID { get }
}

extension Method {

    // MARK: Method
    public var using: [Capability.Key] { [.core, .mail] }
}
