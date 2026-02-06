import Foundation
import MIME
import NIOIMAPCore

public struct InternetMessageDate: Sendable {
    public let date: Date
    public let timeZone: TimeZone

    public init(_ date: Date, timeZone: TimeZone = .current) {
        self.date = date
        self.timeZone = timeZone
    }

    init(internetMessageDate: NIOIMAPCore.InternetMessageDate?) throws {
        guard let internetMessageDate else {
            throw MIMEError.dateNotDecoded("nil")
        }
        date = try RFC822DateFormatter().date(from: String(internetMessageDate))
        timeZone = try TimeZone(internetMessageDate: internetMessageDate)
    }
}

extension TimeZone {
    init(internetMessageDate: NIOIMAPCore.InternetMessageDate) throws {
        self = try Self(internetMessageDate: String(internetMessageDate))
    }

    init(internetMessageDate string: String) throws {
        let string: String =
            string
            .replacingOccurrences(of: "+", with: " +")
            .replacingOccurrences(of: "-", with: " -")
            .replacingOccurrences(of: "(", with: " ")
            .replacingOccurrences(of: ")", with: "")
            .components(separatedBy: " ")
            .last!
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if string.hasPrefix("+") || string.hasPrefix("-"), let secondsFromGMT: Int = Int(string) {
            guard let timeZone: Self = Self(secondsFromGMT: secondsFromGMT) else {
                throw MIMEError.dateNotDecoded(string)
            }
            print(timeZone)
            self = timeZone
        } else {
            guard let timeZone: Self = Self(abbreviation: string) else {
                throw MIMEError.dateNotDecoded(string)
            }
            print(timeZone)
            self = timeZone
        }
    }
}
