// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import MIME

public struct EmailAttachment: Sendable {
    public typealias ContentDisposition = MIME.ContentDisposition
    public typealias ContentID = MIME.ContentID

    public let contentDisposition: ContentDisposition
    public let contentID: ContentID?
    public let contentType: ContentType
    public let data: Data

    public init(
        data: Data,
        contentType: ContentType,
        contentDisposition: ContentDisposition? = nil,
        contentID: ContentID? = nil
    ) {
        self.contentDisposition = contentDisposition ?? .attachment
        self.contentID = contentID
        self.contentType = contentType
        self.data = data
    }

    var links: [String] {
        var links: [String] = []
        if let contentID {
            links.append(contentID.description)
            if let url: URL = try? URL(contentID: contentID) {
                links.append(url.absoluteString)
            }
        }
        if let url: URL = try? URL(contentDisposition: contentDisposition) {
            links.append(url.absoluteString)
        }
        return links
    }
}

extension Data {
    func base64EncodedURLString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
}

extension URL {
    init(attachment: EmailAttachment) {
        self.init(string: "data:\(attachment.contentType);base64,\(attachment.data.base64EncodedURLString())")!
    }
}
