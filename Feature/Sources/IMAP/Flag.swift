import NIOIMAPCore

public typealias Flag = NIOIMAPCore.Flag

extension Flag: @retroactive CustomStringConvertible {

    // MARK: CustomStringConvertible
    public var description: String { String(self) }
}
