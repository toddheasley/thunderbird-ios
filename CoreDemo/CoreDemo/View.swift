import SwiftUI

extension View {
    func disableAutoFormatting() -> some View {
        autocorrectionDisabled()
            #if os(iOS)
        .textInputAutocapitalization(.never)
            #endif
    }
}
