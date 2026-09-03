// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

extension View {
    func disableAutoFormatting() -> some View {
        autocorrectionDisabled()
            #if os(iOS)
        .textInputAutocapitalization(.never)
            #endif
    }
}
