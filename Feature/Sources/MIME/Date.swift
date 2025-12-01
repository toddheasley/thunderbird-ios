import Foundation

/// Multipart "date-time" format described in [RFC 822](https://www.rfc-editor.org/rfc/rfc822#section-5.1)
extension Date {
    public func rfc822Format(_ timeZone: TimeZone = .gmt) -> String {
        RFC822DateFormatter(timeZone).string(from: self)
    }
}

/// A formatter that converts between dates and their [RFC 822](https://www.rfc-editor.org/rfc/rfc822#section-5.1) `date-time` string representations.
// swift-format-ignore
public func RFC822DateFormatter(_ timeZone: TimeZone = .gmt) -> DateFormatter {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "dd MM yy; hh:mm:ss zzz"  // RFC 822 "date-time" format
    formatter.timeZone = timeZone
    return formatter
}
