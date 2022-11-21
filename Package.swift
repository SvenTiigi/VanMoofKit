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
    dependencies: [
        .package(
            url: "https://github.com/krzyzanowskim/CryptoSwift",
            exact: "1.6.0"
        )
    ],
    targets: [
        .target(
            name: "VanMoofKit",
            dependencies: [
                "CryptoSwift"
            ],
            path: "Sources"
        )
    ]
)
