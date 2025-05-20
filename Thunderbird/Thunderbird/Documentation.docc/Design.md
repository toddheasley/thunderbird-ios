# App Design

Technical overview of project organization and architecture

## Project Structure

In the context of Thunderbird for iOS (Tfi), "project" means both, figuratively, a map of the product and, literally, an [Xcode project file.](https://developer.apple.com/documentation/xcode/creating-an-xcode-project-for-an-app) In this case we're using a [workspace](https://developer.apple.com/documentation/xcode/projects-and-workspaces) to develop Tfi as a thin Xcode project that depends on libraries organized into local packages.

### Thunderbird Project

`Thunderbird.xcodeproj` starts with a single SwiftUI app target, `Thunderbird`. Additional targets will be added to support things like widgets, rich notifications and/or watchOS extensions.

##### Documentation

The Xcode project includes a [documentation catalog](https://developer.apple.com/documentation/xcode/adding-supplemental-content-to-a-documentation-catalog) for publishing additional articles (like this one) alongside the generated [DocC](https://www.swift.org/documentation/docc) documentation.

##### Localization

Tfi intends to launch with language support comparable to [Thunderbird for Android](https://github.com/thunderbird/thunderbird-android) (TfA) by extending and using the same [Weblate translations](hosted.weblate.org/projects/tb-android), published as `Localizable.strings`. User-facing string localization can then be accomplished automatically using [`LocalizedStringKey`](https://developer.apple.com/documentation/swiftui/localizedstringkey) and SwiftUI.

### Core Package

App- and system-level services belong to `Core`, starting with these libraries:

* `Settings`: Set and remember app-level theme and display configuration.
* `FeatureFlag`: Toggle alternate app functionality.
* `Logging`: Record app events in device system log.

### Feature Package

Features are the backend functionality for the app, starting with these libraries:

* `Account`: Manage and remember user accounts; attach profiles and mail settings.
* `JMAP` / `IMAP`: Connect to mail servers and retrieve folders and messages.
* `SMTP`: Send mail.

### Bolt Package

[Bolt](https://bolt.thunderbird.net) is Thunderbird's design system. `Bolt` package is where all design system things live, as well as any reusable UI components:

* `BoltUI`: Vend SwiftUI design system components
* `Editor`: Read and compose messages in [WKWebView.](https://developer.apple.com/documentation/webkit/wkwebview)

-----

`BoltUI` is unusual, because it will depend on SwiftUI and implement views specifically for iOS/watchOS. Generally, libraries follow these conventions:

* Corresponding test target containing unit test coverage for logic and anything computed; use [Swift Testing.](https://developer.apple.com/documentation/testing)
* Configurable programming interfaces; no user interface, no user-facing strings
* Explicit interfaces and responsibility, encapsulated for being moved into separate repositories and reused in other apps

### Additional Workspace Components

* `docs` is the designated location for publishing web version of project documentation to [GitHub Pages.](https://pages.github.com)
* `Thunderbird.xctestplan` aggregates tests from both app project and packaged libraries.
