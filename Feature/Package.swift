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
        .executable(
            name: "autoconfig",
            targets: [
                "AutoconfigurationCLI"
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
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "main"),
        .package(url: "https://github.com/apple/swift-async-dns-resolver", branch: "main"),
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
            name: "Autoconfiguration",
            dependencies: [
                .product(name: "AsyncDNSResolver", package: "swift-async-dns-resolver")
            ]),
        .executableTarget(
            name: "AutoconfigurationCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Autoconfiguration"
            ]),
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
