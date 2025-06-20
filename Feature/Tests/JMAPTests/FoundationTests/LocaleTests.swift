import Testing
@testable import JMAP
import Foundation

struct LocaleTests {
    @Test func acceptedLanguages() {
        #expect(Locale.acceptedLanguages().hasPrefix(Locale.preferredLanguages.first ?? "*"))
        #expect(Locale.acceptedLanguages().hasSuffix("*;q=0.5"))
    }
}
