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
    targets: [
        .target(
            name: "Core",
            dependencies: [
                "Autodiscover",
                "Log"
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
