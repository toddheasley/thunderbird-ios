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
            name: "Log",
            targets: [
                "Log"
            ])
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
            ])
    ])
