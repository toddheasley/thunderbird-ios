// swift-tools-version: 6.0

import PackageDescription

let package: Package = Package(
    name: "Core",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: "Core",
            targets: [
                "Core"
            ]),
        .executable(
            name: "weblate",
            targets: [
                "Weblate"
            ]),
        .library(
            name: "Autodiscover",
            targets: [
                "Autodiscover"
            ]),
        .library(
            name: "Log",
            targets: [
                "Log"
            ])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "main")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                "Autodiscover",
                "Log"
            ]),
        .executableTarget(
            name: "Weblate",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .target(name: "Autodiscover"),
        .testTarget(
            name: "AutodiscoverTests",
            dependencies: [
                "Autodiscover"
            ]),
        .target(name: "Log"),
        .testTarget(
            name: "LogTests",
            dependencies: [
                "Log"
            ])
    ])
