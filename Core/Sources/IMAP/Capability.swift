import NIOCore
import NIOIMAP

public typealias Capability = NIOIMAPCore.Capability

extension NIOIMAPCore.Capability: @retroactive CustomStringConvertible {

    // MARK: CustomStringConvertible
    public var description: String { name }
}
