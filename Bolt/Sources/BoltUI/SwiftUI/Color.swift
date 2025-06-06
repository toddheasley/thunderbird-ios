import SwiftUI
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension Color {
    public static func neutral(_ style: Style) -> Self {
        switch style {
        case .base: Self(Self(hex: 0xFEFFFF), Self(hex: 0x1A202C))
        case .lower: Self(Self(hex: 0xF7F7F7), Self(hex: 0x18181B))
        case .border: Self(Self(hex: 0xD9D9DE), Self(hex: 0x262D3B))
        case .borderIntense: Self(Self(hex: 0x91939F), Self(hex: 0x5E7799))
        }
    }

    public static func primary(_ state: State = .default) -> Self {
        switch state {
        case .soft: Self(Self(hex: 0xF0F8FF), Self(hex: 0x262C40))
        case .default: Self(Self(hex: 0x1373D9), Self(hex: 0x58C9FF))
        case .hover: Self(Self(hex: 0x175FB6), Self(hex: 0x32AEFF))
        case .pressed: Self(Self(hex: 0x19518F), Self(hex: 0x1B90F5))
        }
    }

    public static func secondary(_ state: State = .default) -> Self {
        switch state {
        case .soft: Self(Self(hex: 0xFAF5FF), Self(hex: 0x3A0764))
        case .default: Self(Self(hex: 0x6B21A8), Self(hex: 0xF5E8FF))
        case .hover: Self(Self(hex: 0x571C87), Self(hex: 0xECD5FF))
        case .pressed: Self(Self(hex: 0x3A0764), Self(hex: 0xDDB4FE))
        }
    }

    public static func success(_ state: State = .default) -> Self {
        switch state {
        case .soft: Self(Self(hex: 0xF4F9F4), Self(hex: 0x082B16))
        case .default: Self(Self(hex: 0x1D783B), Self(hex: 0xDEFAE7))
        case .hover: Self(Self(hex: 0x1C5F32), Self(hex: 0xC0F2CF))
        case .pressed: Self(Self(hex: 0x194E2C), Self(hex: 0x81D4B5))
        }
    }

    public static func warning(_ state: State = .default) -> Self {
        switch state {
        case .soft: Self(Self(hex: 0xFEFAE8), Self(hex: 0x423606))
        case .default: Self(Self(hex: 0xFACC15), Self(hex: 0xFEF2C3))
        case .hover: Self(Self(hex: 0xEABD08), Self(hex: 0xFEE78A))
        case .pressed: Self(Self(hex: 0xCAA204), Self(hex: 0xFDD847))
        }
    }

    public static func critical(_ state: State = .default) -> Self {
        switch state {
        case .soft: Self(Self(hex: 0xFEF2F2), Self(hex: 0x7F1D1D))
        case .default: Self(Self(hex: 0x991B1B), Self(hex: 0xFCA5A5))
        case .hover: Self(Self(hex: 0x7F1D1D), Self(hex: 0xF87171))
        case .pressed: Self(Self(hex: 0x450A0A), Self(hex: 0xEF4444))
        }
    }

    public static func text(_ context: Context) -> Self {
        switch context {
        case .base: Self(Self(hex: 0x1A202C), Self(hex: 0xEEEEF0))
        case .secondary: Self(Self(hex: 0x4C4D58), Self(hex: 0xE4E4E7))
        case .muted: Self(Self(hex: 0x737584), Self(hex: 0x7F94AC))
        case .highlight: Self(Self(hex: 0x1373D9), Self(hex: 0x58C9FF))
        case .warning: Self(Self(hex: 0x713F12), Self(hex: 0xFEE78A))
        case .critical: Self(Self(hex: 0xDC2626), Self(hex: 0xEF4444))
        case .success: Self(Self(hex: 0x1D783B), Self(hex: 0x55D37E))
        }
    }

    public static func accent(_ accent: Accent) -> Self {
        switch accent {
        case .teal: Self(Self(hex: 0x25A6A0), Self(hex: 0xA3ECE3))
        case .blue: Self(Self(hex: 0x58C9FF), Self(hex: 0x58C9FF))
        case .purple: Self(Self(hex: 0xAE55F7), Self(hex: 0x8022CE))
        case .orange: Self(Self(hex: 0xEA7308), Self(hex: 0xFEC18A))
        case .pink: Self(Self(hex: 0xE247C4), Self(hex: 0xFBD3F6))
        case .ink: Self(Self(hex: 0x6E6F9B), Self(hex: 0xC3CADE))
        }
    }

    public enum Style: String, CaseIterable, CustomStringConvertible, Identifiable {
        case base, lower, border, borderIntense

        static var raised: Self { .base }
        static var subtle: Self { .lower }

        // MARK: CustomStringConvertible
        public var description: String { rawValue }

        // MARK: Identifiable
        public var id: String { rawValue }
    }

    public enum State: String, CaseIterable, CustomStringConvertible, Identifiable {
        case soft, `default`, hover, pressed

        // MARK: CustomStringConvertible
        public var description: String { rawValue }

        // MARK: Identifiable
        public var id: String { rawValue }
    }

    public enum Context: String, CaseIterable, CustomStringConvertible, Identifiable {
        case base, secondary, muted, highlight, warning, critical, success

        // MARK: CustomStringConvertible
        public var description: String { rawValue }

        // MARK: Identifiable
        public var id: String { rawValue }
    }

    public enum Accent: String, CaseIterable, CustomStringConvertible, Identifiable {
        case teal, blue, purple, orange, pink, ink

        // MARK: CustomStringConvertible
        public var description: String { rawValue }

        // MARK: Identifiable
        public var id: String { rawValue }
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        self.init(red: hex.red, green: hex.green, blue: hex.blue, opacity: opacity)
    }
}

extension Color {
    var isDynamic: Bool { resolved().dark != nil }

    func resolve(for colorScheme: ColorScheme) -> Resolved {
        resolve(in: EnvironmentValues(colorScheme))
    }

    func resolved() -> (any: Resolved, dark: Resolved?) {
        let resolved: (Resolved, Resolved) = (resolve(for: .light), resolve(for: .dark))
        return (resolved.0, resolved.1 != resolved.0 ? resolved.1 : nil)
    }

    init(_ any: Resolved, _ dark: Resolved?) {
        self.init(Self(any), Self(dark ?? any))
    }

    init(_ any: Self, _ dark: Self? = nil) {
        #if os(watchOS)
        self = dark ?? any  // Apple Watch uses dark color, if available
        #else
        if let dark, dark != any {
            #if canImport(AppKit)
            self.init(
                nsColor: NSColor(name: nil) { appearance in
                    switch appearance.name {
                    case .darkAqua:
                        return NSColor(dark)
                    default:
                        return NSColor(any)
                    }
                })
            #elseif canImport(UIKit)
            self.init(
                uiColor: UIColor { traits in
                    switch traits.userInterfaceStyle {
                    case .dark:
                        return UIColor(dark)
                    default:
                        return UIColor(any)
                    }
                })
            #endif
        } else {
            self = any
        }
        #endif
    }
}

private extension EnvironmentValues {
    init(_ colorScheme: ColorScheme) {
        self.init()
        self.colorScheme = colorScheme
    }
}

private struct ColorPreview: View {
    let text: LocalizedStringKey
    let colors: [Color]

    init(_ text: LocalizedStringKey, colors: [Color]) {
        self.text = text
        self.colors = colors
    }

    // MARK: View
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(text)
                    .textStyle(.subhead)
                    .foregroundStyle(.secondary)
                HStack {
                    ForEach(colors, id: \.self) { color in
                        Swatch(color)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

private struct Swatch: View {
    let color: Color
    let size: CGSize

    init(_ color: Color, size: CGSize = CGSize(width: 44.0, height: 44.0)) {
        self.color = color
        self.size = size
    }

    // MARK: View
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size.width, height: size.height)
    }
}

#Preview("Color") {
    ScrollView {
        VStack {
            ColorPreview("neutral", colors: Color.Style.allCases.map { .neutral($0) })
            ColorPreview("primary", colors: Color.State.allCases.map { .primary($0) })
            ColorPreview("secondary", colors: Color.State.allCases.map { .secondary($0) })
            ColorPreview("success", colors: Color.State.allCases.map { .success($0) })
            ColorPreview("warning", colors: Color.State.allCases.map { .warning($0) })
            ColorPreview("critical", colors: Color.State.allCases.map { .critical($0) })
            ColorPreview("text + icon", colors: Color.Context.allCases.map { .text($0) })
            ColorPreview("accent", colors: Color.Accent.allCases.map { .accent($0) })
        }
    }
    .containerRelativeFrame(.horizontal)
}
