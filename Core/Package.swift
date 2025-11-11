// swift-tools-version: 6.2

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
        .library(
            name: "Log",
            targets: [
                "Log"
            ]),
        .executable(
            name: "weblate",
            targets: [
                "Weblate"
            ])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "main")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                "Log"
            ]),
        .target(name: "Log"),
        .testTarget(
            name: "LogTests",
            dependencies: [
                "Log"
            ]),
        .executableTarget(
            name: "Weblate",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ])
    ])
