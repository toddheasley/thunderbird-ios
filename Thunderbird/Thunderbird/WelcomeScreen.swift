import SwiftUI
import Account

struct WelcomeScreen: View {
    init(_ isPresented: Binding<Bool> = .constant(false)) {
        _isPresented = isPresented
    }
    @Environment(Accounts.self) private var accounts: Accounts
    @Environment(\.openURL) private var openURL
    @Environment(FeatureFlags.self) private var featureFlags: FeatureFlags
    @Binding private var isPresented: Bool

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
            if(featureFlags.flagForKey(key: "featureX")){
                Text("onboarding_welcome_text_alpha")
                    .multilineTextAlignment(.center)
                    .opacity(0.75)
                    .padding()
            }
            Spacer()
            Spacer()
            Button(action: {
                isPresented = true
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
            Background()
        }
    }
}

#Preview("Welcome Screen") {
    @Previewable @State var isPresented: Bool = false

    WelcomeScreen($isPresented)
        .sheet(isPresented: $isPresented) {
            EmptyView()
                .presentationDragIndicator(.visible)
        }
}

private struct Background: View {

    // MARK: View
    var body: some View {
        GeometryReader { proxy in
            Image.background
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .opacity(proxy.size.width > 444.0 ? 0.0 : 1.0)
        }
        .ignoresSafeArea()
    }
}

private extension Image {
    static var background: Self { Self("Welcome/Background") }
    static var logo: Self { Self("Welcome/Logo") }
}
