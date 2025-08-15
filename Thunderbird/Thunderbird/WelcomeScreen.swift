import SwiftUI
import Account

struct WelcomeScreen: View {
    init(_ getStarted: Binding<Bool> = .constant(false)) {
        _getStarted = getStarted
    }

    @Environment(\.openURL) private var openURL
    @Binding private var getStarted: Bool

    // MARK: View
    var body: some View {
        VStack {
            Spacer()
            Image.logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .accessibilityLabel("app_name")
                .frame(height: 172.0)
            Text("onboarding_welcome_text")
                .multilineTextAlignment(.center)
                .opacity(0.75)
                .padding()
            Spacer()
            Spacer()
            Button(action: {
                getStarted = true
            }) {
                Text("onboarding_welcome_start_button")
                    .padding(5.5)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            Spacer()
            Text("onboarding_welcome_developed_by")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .font(.caption)
                .padding()
        }
    }
}

#Preview("Welcome Screen") {
    @Previewable @State var getStarted: Bool = false

    WelcomeScreen($getStarted)
        .alert("Get started", isPresented: $getStarted) {

        }
}

private extension Image {
    static var logo: Self { Self("Welcome/Logo") }
}

#Preview("Welcome Logo Image") {
    Image.logo
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding()
}
