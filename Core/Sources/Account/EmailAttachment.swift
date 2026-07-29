// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import MIME

public struct EmailAttachment: Sendable {
    public typealias ContentDisposition = MIME.ContentDisposition

    public let contentDisposition: ContentDisposition
    public let contentType: ContentType
    public let data: Data

    public init(
        data: Data,
        contentType: ContentType,
        contentDisposition: ContentDisposition? = nil
    ) {
        self.contentDisposition = contentDisposition ?? .attachment
        self.contentType = contentType
        self.data = data
    }
}
