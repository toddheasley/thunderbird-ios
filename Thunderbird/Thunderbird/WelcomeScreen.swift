import SwiftUI

struct WelcomeScreen: View {
    init(_ getStarted: Binding<Bool> = .constant(false)) {
        _getStarted = getStarted
    }

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
        .wallpaper()
    }
}

#Preview("Welcome Screen") {
    @Previewable @State var getStarted: Bool = false

    WelcomeScreen($getStarted)
        .alert("Get started", isPresented: $getStarted) {

        }
}

private extension View {
    func wallpaper() -> some View {
        modifier(WelcomeWallpaperViewModifier())
    }
}

struct WelcomeWallpaperViewModifier: ViewModifier {

    // MARK: ViewModifier
    func body(content: Content) -> some View {
        content
            .background {
                Image.wallpaper
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.97)
                    .ignoresSafeArea()
                    .containerRelativeFrame(.horizontal)
                    .background(Color.background)
            }
    }
}

#Preview("Welcome Wallpaper View Modifier") {
    Rectangle()
        .fill(.clear)
        .modifier(WelcomeWallpaperViewModifier())
}

private extension Image {
    static var wallpaper: Self { Self("Welcome/Wallpaper") }
    static var logo: Self { Self("Welcome/Logo") }
}

#Preview("Welcome Wallpaper Image") {
    Image.wallpaper
        .resizable()
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea()
}

#Preview("Welcome Logo Image") {
    Image.logo
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding()
}

private extension Color {
    static var background: Self { Self("Welcome/Background") }
}

#Preview("Welcome Background Color") {
    Color.background
        .ignoresSafeArea()
}
