import SwiftUI
import Testing
@testable import Bolt

struct ColorTests {
    @Test func hexInit() {
        #expect(Color(hex: 0xFF3300, opacity: 0.5) == Color(red: 1.0, green: 0.2, blue: 0.0, opacity: 0.5))
    }

    @Test func isDynamic() {
        #expect(!Color(.black, nil).isDynamic)
        #expect(!Color(.black, .black).isDynamic)
        #expect(Color(.black, .white).isDynamic)
    }

    @Test func resolveForColorScheme() {
        #expect(Color(.black, .white).resolve(for: .light).linearRed == 0.0)
        #expect(Color(.black, .white).resolve(for: .dark).linearRed == 1.0)
        #expect(Color(.black, nil).resolve(for: .light).linearRed == 0.0)
        #expect(Color(.black, nil).resolve(for: .dark).linearRed == 0.0)
    }
}
