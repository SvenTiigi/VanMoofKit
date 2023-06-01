// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "VanMoofKit",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .macOS(.v12),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "VanMoofKit",
            targets: [
                "VanMoofKit"
            ]
        )
    ],
    targets: [
        .target(
            name: "VanMoofKit",
            path: "Sources"
        ),
        .testTarget(
            name: "VanMoofKitTests",
            dependencies: [
                "VanMoofKit"
            ],
            path: "Tests"
        )
    ]
)
