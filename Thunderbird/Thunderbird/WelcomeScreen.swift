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
            WelcomeLogo()
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
                .font(.caption)
                .opacity(0.75)
                .padding()
        }
        .background {
            WelcomeBackground()
        }
    }
}

#Preview("Welcome Screen") {
    @Previewable @State var getStarted: Bool = false

    WelcomeScreen($getStarted)
}

private struct WelcomeLogo: View {

    // MARK: View
    var body: some View {
        Image.logo
            .resizable()
            .aspectRatio(contentMode: .fit)
            .accessibilityLabel("app_name")
    }
}

#Preview("Welcome Logo") {
    WelcomeLogo()
        .padding()
}

private struct WelcomeBackground: View {

    // MARK: View
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(.clear)
                    .frame(width: geometry.size.width * 2.0)
                Image.background
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .containerRelativeFrame(.horizontal)
        .ignoresSafeArea()
    }
}

#Preview("Welcome Background") {
    WelcomeBackground()
}

private extension Image {
    static var background: Self { Self("Welcome/Background") }
    static var logo: Self { Self("Welcome/Logo") }
}
