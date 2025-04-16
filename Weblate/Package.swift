// swift-tools-version: 6.1

import PackageDescription

let package: Package = Package(
    name: "Weblate", platforms: [
        .macOS(.v15)
    ], products: [
        .executable(name: "weblate-sync", targets: [
            "WeblateSync"
        ]),
        .library(name: "Weblate", targets: [
            "Weblate"
        ])
    ], dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "main")
    ], targets: [
        .executableTarget(name: "WeblateSync", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "Weblate"
        ]),
        .target(name: "Weblate"),
        .testTarget(name: "WeblateTests", dependencies: [
            "Weblate"
        ])
    ])
