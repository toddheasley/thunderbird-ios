import NIOIMAPCore

public typealias UID = NIOIMAPCore.UID
public typealias UIDSet = NIOIMAPCore.UIDSetNonEmpty

extension UID: @retroactive CustomStringConvertible {

    // MARK: CustomStringConvertible
    public var description: String { debugDescription }
}

extension UIDSet {
    init(_ uid: UID) {
        self.init(range: MessageIdentifierRange(uid))
    }
}
