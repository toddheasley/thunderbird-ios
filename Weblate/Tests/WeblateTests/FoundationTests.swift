import Foundation
import Testing
@testable import Weblate

struct URLSessionTests {
    @Test func languages() async throws {
        let languages: [Language] = try await URLSession.shared.languages(project: "tb-android")
        #expect(languages.count == 65)
    }
}

struct URLRequestTests {
    @Test func request() {
        let url: URL = URL(string: "https://hosted.weblate.org/api/")!
        let token: String = UUID().uuidString
        #expect(
            URLRequest.request(url, token: token).allHTTPHeaderFields == [
                "Accept": "application/json",
                "Authorization": "Token \(token)"
            ])
        #expect(
            URLRequest.request(url).allHTTPHeaderFields == [
                "Accept": "application/json"
            ])
    }
}

struct URLTests {
    @Test func translations() {
        #expect(URL.translations("app-strings", project: "tb-android").absoluteString == "https://hosted.weblate.org/api/components/tb-android/app-strings/translations/")
    }

    @Test func languages() {
        #expect(URL.languages(project: "tb-android").absoluteString == "https://hosted.weblate.org/api/projects/tb-android/languages/")
    }
}
