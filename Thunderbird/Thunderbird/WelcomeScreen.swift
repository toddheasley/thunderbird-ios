import SwiftUI
import Account

struct WelcomeScreen: View {
    @Environment(\.openURL) private var openURL
    @State private var isPresented: Bool = false

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
            Button(action: {}) {
                Text("onboarding_welcome_start_button")
                    .padding(5.5)
            }
            .buttonStyle(.borderedProminent)
            .simultaneousGesture(
                LongPressGesture().onEnded { result in
                    isPresented.toggle()
                }
            )
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    openURL(.donate)
                }
            )
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
        .sheet(isPresented: $isPresented) {
            JMAPView()
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview("Welcome Screen") {
    WelcomeScreen()
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

private extension URL {
    static let donate: Self = Self(string: "https://www.thunderbird.net/donate/mobile/?form=tfi")!
}
