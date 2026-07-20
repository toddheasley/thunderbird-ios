// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import JMAP
import MIME

public struct EmailBody: CustomStringConvertible, Sendable {
    public let attachments: [EmailAttachment]  // Both inline and attached
    public let preview: String?
    public let html: String?  // Base64-encoded inline media attachments
    public let text: String?

    public init(html: String? = nil, text: String? = nil, attachments: [EmailAttachment] = [], preview: String? = nil) {
        self.attachments = attachments
        self.preview = preview
        self.html = html
        self.text = text
    }

    // MARK: CustomStringConvertible
    public var description: String { text ?? html ?? "" }
}

extension EmailBody {
    init(body: MIME.Body?) throws {
        guard let body else {
            throw URLError(.resourceUnavailable)
        }
        var components: MIME.Part.Components = ([], [], [])
        do {
            for part in body.parts {
                let _components: MIME.Part.Components = try part.components()
                components.html += _components.html
                components.text += _components.text
                components.0 += _components.0
            }
        } catch {
            print("*** \(error)")
            throw error
        }
        let html: String? = !components.html.isEmpty ? components.html.joined() : nil
        let text: String? = !components.text.isEmpty ? components.text.joined() : nil
        let preview: String? = nil  // TODO: Generate preview text
        self.init(html: html, text: text, attachments: components.0, preview: preview)
    }

    init(email: JMAP.Email) throws {
        // TODO: JMAP email body decoding and assembly not implemented
        throw URLError(.cancelled)
    }
}

extension MIME.Part {
    typealias Components = ([EmailAttachment], html: [String], text: [String])

    func components() throws -> Components {
        print("*** ======== components()")
        print("*** data: \(data.count)")
        var components: Components = ([], [], [])
        print("*** contentTransferEncoding: \(contentTransferEncoding?.description ?? "nil")")
        switch contentType {
        case .multipart(let subtype, _):
            switch subtype {
            case .alternative:
                print("*** multipart/alt")
            case .related:
                print("*** multipart/rel")
            case .mixed:
                print("*** multipart/mix")
                fallthrough
            default:
                print("*** multipart/\(subtype) (default)")
            }
        case .text(let subtype, let characterSet):
            let string: String = try String(
                contentTransferEncoding,
                data: data,
                encoding: characterSet?.encoding ?? .utf8
            )
            switch subtype {
            case .html:
                components.html.append(string)
            case .plain:
                fallthrough
            default:
                components.text.append(string)
            }
        case .message(let subtype):
            print("*** subtype: \(subtype)")
            let string: String = try String(contentTransferEncoding, data: data)
            components.text.append(string)
        default:
            print("*** \(contentType) (default)")
        }
        print("*** --------")
        return components
    }
}

extension MIME.CharacterSet {
    var encoding: String.Encoding? {
        switch self {
        case .ascii: .ascii
        case .iso8859: .isoLatin1
        case .utf8: .utf8
        default: nil
        }
    }
}

extension String {
    init(_ transferEncoding: ContentTransferEncoding?, data: Data, encoding: Encoding = .utf8) throws {
        switch transferEncoding {
        case .base64:
            try self.init(base64: data, encoding: encoding)
        case .quotedPrintable:
            try self.init(quotedPrintable: data, encoding: encoding)
        default:
            guard let string: Self = Self(data: data, encoding: encoding) else {
                throw MIMEError.dataNotDecoded(data, encoding: encoding)
            }
            self = string
        }
    }
}
