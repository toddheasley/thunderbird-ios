import NIOIMAPCore

public typealias SequenceNumber = NIOIMAPCore.SequenceNumber
public typealias SequenceSet = NIOIMAPCore.MessageIdentifierSetNonEmpty<SequenceNumber>

extension SequenceNumber: @retroactive CustomStringConvertible {

    // MARK: CustomStringConvertible
    public var description: String { debugDescription }
}

extension SequenceSet {
    init(_ sequenceNumber: SequenceNumber) {
        self.init(range: MessageIdentifierRange(sequenceNumber))
    }
}
