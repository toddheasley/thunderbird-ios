import Foundation
import CoreGraphics

// Extend `Int` to decode and encode RGB color values
extension Int {
    var red: CGFloat { CGFloat((self & 0xFF0000) >> 16) / 255.0 }
    var green: CGFloat { CGFloat((self & 0x00FF00) >> 8) / 255.0 }
    var blue: CGFloat { CGFloat(self & 0x00FF) / 255.0 }
    
    init(_ components: [CGFloat]? = nil) {
        switch (components ?? []).count {
        case 4: // RGB
            self = (Int(components![0] * 255.0) << 16) + (Int(components![1] * 255.0) << 8) + (Int(components![2] * 255.0) << 0)
        case 2: // Grayscale
            self = (Int(components![0] * 255.0) << 16) + (Int(components![0] * 255.0) << 8) + (Int(components![0] * 255.0) << 0)
        default:
            self = 0
        }
    }
}

// Extend `String` to decode and encode hex values
extension String {
    var hex: Int {
        var hex: UInt64 = 0
        Scanner(string: normalizedHexString).scanHexInt64(&hex)
        return Int(hex)
    }
    
    init(hex: Int) {
        self = "#\(Self(hex, radix: 16).normalizedHexString)"
    }
    
    private var normalizedHexString: Self {
        let string: Substring = uppercased().replacingOccurrences(of: "[^A-F0-9]+", with: "", options: .regularExpression).prefix(6)
        switch string.count {
        case 3:
            return string.map { character in
                return Self(repeating: character, count: 2)
            }.joined()
        case 1:
            return Self(repeating: string.first!, count: 6)
        default:
            return "\(Self(repeating: "0", count: 6 - string.count))\(string)"
        }
    }
}
