// swift-tools-version: 6.2

import PackageDescription

let package: Package = Package(
    name: "Bolt",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: "BoltUI",
            targets: [
                "BoltUI"
            ]),
        .library(
            name: "Editor",
            targets: [
                "Editor"
            ])
    ],
    targets: [
        .target(
            name: "BoltUI",
            dependencies: [
                "Editor"
            ]),
        .testTarget(
            name: "BoltUITests",
            dependencies: [
                "BoltUI"
            ]),
        .target(name: "Editor"),
        .testTarget(
            name: "EditorTests",
            dependencies: [
                "Editor"
            ])
    ])
