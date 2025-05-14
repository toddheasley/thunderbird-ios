# App Design

Technical overview of project organization and architecture

## Project Structure

[Local Swift packages](https://developer.apple.com/documentation/xcode/organizing-your-code-with-local-packages) break app functionality into discrete libraries. Each library is a namespaced module exposing the smallest possible public interface. For project legibility and developer ergonomics, packages contain multiple libraries that depend on each other and/or are always used together, plus an "umbrella" library that rolls together the package's child libraries and exports them as a single `import`.

Concretely, `Thunderbird.xcworkspace` includes two local packages, `Mail` and `Bolt`.

### Mail Package

`Mail` includes at least 4 library targets:

* `Account`: Configure and persist mail account settings, identities, incoming and outgoing server configurations.
* `JMAP`, `IMAP`: Connect to mail servers and retrieve folders and messages.
* `SMTP`: Send mail.
* `Mail`: Export all libraries in package.

### Bolt Package

`Bolt` includes 2 library targets:

* `Bolt`: Vend SwiftUI components of [Thunderbird's design system.](https://bolt.thunderbird.net) 
* `Editor`: Read and compose messages in [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview) and [GeckoView](https://github.com/mozilla/geckoview)

-----

`Bolt` is unusual, because it will depend on SwiftUI and implement UI specifically for iOS/watchOS. Generally, libraries follow these conventions:

* Corresponding test target containing unit test coverage for logic and anything computed; use [Swift Testing.](https://developer.apple.com/documentation/testing)
* Configurable programming interfaces; no user interface, no user-facing strings
* Modular: explicit interfaces and responsibility, encapsulated for being moved into other repositories and reused in other apps
* Portable: build and run on any Apple platform, at least iOS and macOS

Packages provide the building blocks that `Thunderbird.xcodeproj` assembles into an app.

### Thunderbird Project

The Xcode project starts with a single SwiftUI app target, `Thunderbird`. Additional targets will be needed to support things like widgets, rich notifications and/or watchOS extensions.

`Thunderbird.xctestplan` aggregates tests from both app project and packaged libraries.
