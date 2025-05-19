# App Design

Technical overview of project organization and architecture

## Project Structure

In the context of Thunderbird for iOS (Tfi), "project" means both, figuratively, a map of the product and, literally, an [Xcode project file.](https://developer.apple.com/documentation/xcode/creating-an-xcode-project-for-an-app) In this case we're using a [workspace](https://developer.apple.com/documentation/xcode/projects-and-workspaces) to develop Tfi as a thin Xcode project that depends on libraries organized into local packages.

![Project structure diagram](design-project.svg)

### Thunderbird Project

`Thunderbird.xcodeproj` starts with a single SwiftUI app target, `Thunderbird`. Additional targets will be added to support things like widgets, rich notifications and/or watchOS extensions.

#### Documentation

The Xcode project includes a [documentation catalog](https://developer.apple.com/documentation/xcode/adding-supplemental-content-to-a-documentation-catalog) for publishing additional articles (like this one) alongside the generated [DocC](https://www.swift.org/documentation/docc) documentation.

#### Localization

Tfi intends to launch with language support comparable to [Thunderbird for Android](https://github.com/thunderbird/thunderbird-android) (TfA) by extending and using the same [Weblate translations](hosted.weblate.org/projects/tb-android), published as `Localizable.strings`. User-facing string localization can then be accomplished automatically using [`LocalizedStringKey`](https://developer.apple.com/documentation/swiftui/localizedstringkey) and SwiftUI.

### Swift Packages

[Local Swift packages](https://developer.apple.com/documentation/xcode/organizing-your-code-with-local-packages) break app functionality into discrete libraries. Each library is a module and namespace.

#### Mail Package

`Mail` rolls the entire Thunderbird backend into a unified `@Observable` interface for use in SwiftUI apps. `Mail` starts with 4 library targets:

* `Account`: Configure and persist mail account settings, identities, incoming and outgoing server configurations.
* `JMAP`, `IMAP`: Connect to mail servers and retrieve folders and messages.
* `SMTP`: Send mail.
* `Mail`: Export all libraries in package.

`Account` is the core module with the largest amount of responsibility; the other libraries implement protocols for sending and receiving mail.

![Account model diagram](design-account.svg)

#### Bolt Package

[Bolt](https://bolt.thunderbird.net) is Thunderbird's design system. `Bolt` package is where all design system things live, as well as any reusable UI components:

* `Bolt`: Vend SwiftUI design system components
* `Editor`: Read and compose messages in [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview) and [GeckoView](https://github.com/mozilla/geckoview)

-----

`Bolt` is unusual, because it will depend on SwiftUI and implement UI specifically for iOS/watchOS. Generally, libraries follow these conventions:

* Corresponding test target containing unit test coverage for logic and anything computed; use [Swift Testing.](https://developer.apple.com/documentation/testing)
* Configurable programming interfaces; no user interface, no user-facing strings
* Explicit interfaces and responsibility, encapsulated for being moved into separate repositories and reused in other apps
* Build and run on any Apple platform, at least iOS and macOS

### Additional Workspace Components

* `docs` is the designated location for publishing web version of project documentation to [GitHub Pages.](https://pages.github.com)
* `Thunderbird.xctestplan` aggregates tests from both app project and packaged libraries.
