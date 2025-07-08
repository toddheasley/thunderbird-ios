import JMAP
import SwiftUI

struct JMAPTokenView: View {
    @Environment(JMAPObject.self) private var jmap: JMAPObject
    @State private var text: String = ""
    @FocusState var focused: Bool?

    // MARK: View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10.0) {
                Text("Fastmail JMAP Preview")
                    .font(.headline)
                TextField("Fastmail API token", text: $text)
                    .focused($focused, equals: true)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                Text("Thunderbird can read email from a Fastmail account using a self-issued API token.")
                    .multilineTextAlignment(.leading)
                Link(destination: .help) {
                    Text("Generate a token")
                }
            }
            .padding(.vertical)
            .padding()
            .containerRelativeFrame(.horizontal)
        }
        .onChange(of: text) {
            jmap.token = text
        }
        .onAppear {
            focused = true
        }
    }
}

#Preview("JMAP View") {
    @Previewable @State var jmap: JMAPObject = JMAPObject()

    JMAPTokenView()
        .environment(jmap)
}
