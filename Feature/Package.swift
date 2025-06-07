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
            name: "Mail",
            targets: [
                "Mail"
            ]),
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
        .package(name: "Core", path: "../Core")
    ],
    targets: [
        .target(
            name: "Mail",
            dependencies: [
                "Account",
                "JMAP",
                "IMAP"
            ]),
        .testTarget(
            name: "MailTests",
            dependencies: [
                "Mail"
            ]),
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
        .target(name: "IMAP"),
        .testTarget(
            name: "IMAPTests",
            dependencies: [
                "IMAP"
            ])
    ])
