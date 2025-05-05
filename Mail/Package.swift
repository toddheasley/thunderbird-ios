// swift-tools-version: 6.0

import PackageDescription

let package: Package = Package(
    name: "Mail",
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
            name: "IMAP",
            targets: [
                "IMAP"
            ])
    ],
    targets: [
        .target(
            name: "Mail",
            dependencies: [
                "Account",
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
        .target(name: "IMAP"),
        .testTarget(
            name: "IMAPTests",
            dependencies: [
                "IMAP"
            ])
    ])
