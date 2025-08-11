// swift-tools-version: 6.0

import PackageDescription

let package: Package = Package(
    name: "Feature",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: "Account",
            targets: [
                "Account"
            ]),
        .library(
            name: "JMAP",
            targets: [
                "JMAP"
            ]),
        .library(
            name: "IMAP",
            targets: [
                "IMAP"
            ])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio-imap", from: "0.1.0"),
        .package(name: "Core", path: "../Core")
    ],
    targets: [
        .target(name: "Account"),
        .testTarget(
            name: "AccountTests",
            dependencies: [
                "Account"
            ]),
        .target(
            name: "JMAP",
            dependencies: [
                "Core"
            ]),
        .testTarget(
            name: "JMAPTests",
            dependencies: [
                "JMAP"
            ]),
        .target(
            name: "IMAP",
            dependencies: [
                .product(name: "NIOIMAP", package: "swift-nio-imap")
            ]),
        .testTarget(
            name: "IMAPTests",
            dependencies: [
                "IMAP"
            ])
    ])
