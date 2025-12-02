import Foundation

public enum MIMEError: Error, CustomStringConvertible, Equatable {
    case boundaryLength(Int)
    case boundaryNotASCII
    case characterSetNotFound
    case dataNotDecoded(Data, encoding: String.Encoding? = nil)
    case dataNotFound
    case dataNotQuotedPrintable

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .boundaryLength(let length): "Multipart data boundary length \(length) outside of bounds \(Boundary.bounds)"
        case .boundaryNotASCII: "Multipart data boundary not ASCII"
        case .characterSetNotFound: "Multipart character set not found"
        case .dataNotDecoded(let data, _): "Multipart data not decoded: \(String(data: data, encoding: .ascii) ?? "�")"
        case .dataNotFound: "Multipart data not found"
        case .dataNotQuotedPrintable: "Multipart data not quoted-printable"
        }
    }
}
