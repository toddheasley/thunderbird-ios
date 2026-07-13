// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import JMAP
import MIME

public struct Attachment {

}

public struct EmailBody: CustomStringConvertible {
    public let attachments: [Attachment]  // Both inline and attached
    public let preview: String?
    public let html: String?  // Base64-encoded inline media attachments
    public let text: String?

    // MARK: CustomStringConvertible
    public var description: String { "" }
}

extension MIME.Body {
    init(_ email: JMAP.Email) throws {
        // TODO: JMAP email body encoding and assembly not implemented
        throw URLError(.cancelled)
    }
}

extension MIME.Body {

}
