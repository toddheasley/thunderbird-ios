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
            name: "Autoconfiguration",
            targets: [
                "Autoconfiguration"
            ]),
        .library(
            name: "IMAP",
            targets: [
                "IMAP"
            ]),
        .library(
            name: "JMAP",
            targets: [
                "JMAP"
            ])
    ],
    dependencies: [
        .package(name: "Core", path: "../Core")
    ],
    targets: [
        .target(name: "Account"),
        .testTarget(
            name: "AccountTests",
            dependencies: [
                "Account"
            ]),
        .target(name: "Autoconfiguration"),
        .testTarget(
            name: "AutoconfigurationTests",
            dependencies: [
                "Autoconfiguration"
            ]),
        .target(name: "IMAP"),
        .testTarget(
            name: "IMAPTests",
            dependencies: [
                "IMAP"
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
            ])
    ])
