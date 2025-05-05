// swift-tools-version: 6.1

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
            name: "Bolt",
            targets: [
                "Bolt"
            ])
    ],
    targets: [
        .target(name: "Bolt"),
        .testTarget(
            name: "BoltTests",
            dependencies: [
                "Bolt"
            ])
    ])
