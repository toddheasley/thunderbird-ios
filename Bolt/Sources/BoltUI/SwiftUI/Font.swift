import SwiftUI

extension Font {
    public enum Style: String, CaseIterable, CustomStringConvertible {
        case titleLarge = "title large"
        case title1 = "title 1"
        case title2 = "title 2"
        case title3 = "title 3"
        case body
        case bodyLarge = "body large"
        case bodySmall = "body small"
        case headline
        case subhead
        case footnote
        case caption
        case callout
        
        public func dynamicSize(_ size: DynamicTypeSize) -> CGFloat {
            self.fixedSize
        }
        
        public var fixedSize: CGFloat {
            switch self {
            case .titleLarge: 31.0
            case .title1: 25.0
            case .title2: 19.0
            case .title3, .bodyLarge: 17.0
            case .body: 15.0
            case .bodySmall, .caption: 11.0
            case .headline: 14.0
            case .subhead, .footnote: 12.0
            case .callout: 13.0
            }
        }
        
        public var weight: Font.Weight {
            switch self {
            case .headline: .semibold
            default: .regular
            }
        }
        
        // MARK: CustomStringConvertible
        public var description: String { rawValue }
    }
    
    public static func bolt(_ style: Style = .body, size: DynamicTypeSize = .large) -> Self {
        system(size: style.dynamicSize(.xSmall), weight: style.weight)
    }
}

#Preview("Color") {
    ScrollView {
        VStack(alignment: .leading, spacing: 16.0) {
            Text("Pack my red box with five dozen quality jugs")
                .font(.bolt(.titleLarge))
            Text("The five boxing wizards jump quickly")
                .font(.bolt(.title1))
            Text("Fix problem quickly with galvanized jets")
                .font(.bolt(.title2))
            Text("The wizard quickly jinxed the gnomes before they vaporized")
                .font(.bolt(.title3))
            Text("Pack my red box with five dozen quality jugs")
                .font(.bolt(.body))
            Text("Pack my red box with five dozen quality jugs")
                .font(.bolt(.bodyLarge))
            Text("Heavy boxes perform quick waltzes and jigs")
                .font(.bolt(.bodySmall))
            Text("Show mangled quartz flip vibe exactly")
                .font(.bolt(.headline))
            Text("Show mangled quartz flip vibe exactly")
                .font(.bolt(.subhead))
            Text("Fix problem quickly with galvanized jets")
                .font(.bolt(.footnote))
            Text("Show mangled quartz flip vibe exactly")
                .font(.bolt(.caption))
            Text("The wizard quickly jinxed the gnomes before they vaporized")
                .font(.bolt(.callout))
        }
        .padding()
    }
}
