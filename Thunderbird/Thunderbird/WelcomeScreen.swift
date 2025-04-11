import SwiftUI

struct WelcomeScreen: View {
    @Environment(\.openURL) private var openURL
    
    // MARK: View
    var body: some View {
        VStack(alignment: .center) {
            Image.logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 96.0, maxHeight: 160.0)
                .accessibilityHidden(true)
                .padding()
            Image.logotype
                .resizable()
                .aspectRatio(contentMode: .fit)
                .accessibilityLabel(.headline)
                .padding()
            Text(.subheadline)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding()
            Spacer()
            Button(action: {
                openURL(.donate)
            }) {
                Text(.donate)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            Text(.caption)
                .font(.caption)
                .padding()
        }
        .frame(maxWidth: 512.0)
        .padding()
    }
}

#Preview("Welcome Screen") {
    WelcomeScreen()
}

private extension Image {
    static var logo: Self { Self("Welcome/Logo") }
    static var logotype: Self { Self("Welcome/Logotype") }
}

private extension LocalizedStringKey {
    static let headline: Self = "Thunderbird"
    static let subheadline: Self = "An open source, privacy focused and ad-free email app for iOS."
    static let caption: Self = "Developed by a dedicated team at MZLA Technologies and a global community of volunteers. Part of the Mozilla family."
    static let donate: Self = "Get started"
}

private extension URL {
    static let donate: Self = Self(string: "https://www.thunderbird.net/en-US/donate/mobile/?form=tfi")!
}
