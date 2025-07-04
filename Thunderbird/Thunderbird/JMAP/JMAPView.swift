import JMAP
import SwiftUI

struct JMAPView: View {
    @Environment(JMAPObject.self) private var jmap: JMAPObject

    // MARK: View
    var body: some View {
        NavigationStack {
            if let session = jmap.session {
                JMAPSessionView(session)
            } else {
                Text("null")
            }
        }
        .padding(.top)
    }
}

#Preview("JMAP View") {
    @Previewable @State var jmap: JMAPObject = JMAPObject()

    JMAPView()
        .environment(jmap)
}
