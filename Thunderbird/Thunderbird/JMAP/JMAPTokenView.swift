import JMAP
import SwiftUI

struct JMAPTokenView: View {
    @Environment(JMAPObject.self) private var jmap: JMAPObject
    @State private var text: String = ""

    // MARK: View
    var body: some View {
        ScrollView {
            VStack {
                TextField("Fastmail API token", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled()
            }
            .padding(.vertical)
            .padding()
            .containerRelativeFrame(.horizontal)
        }
        .onChange(of: text) {
            jmap.token = text
        }
    }
}

#Preview("JMAP View") {
    @Previewable @State var jmap: JMAPObject = JMAPObject()

    JMAPTokenView()
        .environment(jmap)
}
