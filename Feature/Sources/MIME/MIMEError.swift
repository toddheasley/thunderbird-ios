import Foundation

public enum MIMEError: Error, CustomStringConvertible, Equatable {
    case boundaryLength(Int)
    case boundaryNotASCII
    case dataNotDecoded(Data)
    case dataNotFound
    case dataNotQuotedPrintable

    // MARK: CustomStringConvertible
    public var description: String {
        switch self {
        case .boundaryLength(let length): "Multipart data boundary length \(length) outside of bounds \(Boundary.bounds)"
        case .boundaryNotASCII: "Multipart data boundary not ASCII"
        case .dataNotDecoded(let data): "Multipart data not decodable: \(String(data: data, encoding: .ascii) ?? "")"
        case .dataNotFound: "Multipart data not found"
        case .dataNotQuotedPrintable: "Multipart data not quoted-printable"
        }
    }
}
