import Foundation
import MIME
import NIOIMAPCore

public typealias GmailLabel = NIOIMAPCore.GmailLabel

extension GmailLabel: @retroactive CustomStringConvertible {

    // MARK: CustomStringConvertible
    public var description: String { makeDisplayString() }
}
