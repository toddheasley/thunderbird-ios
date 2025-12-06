import Foundation

/// A formatter that converts between `Date` and  [RFC 822](https://www.rfc-editor.org/rfc/rfc822#section-5.1) `date-time` string representation
public func RFC822DateFormatter(_ timeZone: TimeZone = .gmt) -> DateFormatter {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "dd MM yy; HH:mm:ss zzz"  // RFC 822 "date-time" format
    formatter.timeZone = timeZone
    return formatter
}

/// Multipart "date-time" format described in [RFC 822](https://www.rfc-editor.org/rfc/rfc822#section-5.1)
extension Date {
    public func rfc822Format(_ timeZone: TimeZone = .gmt) -> String {
        RFC822DateFormatter(timeZone).string(from: self)
    }

    public init(rfc822Format string: String) throws {
        guard let date: Date = RFC822DateFormatter().date(from: string) else {
            throw MIMEError.dateNotDecoded(string)
        }
        self = date
    }
}
