// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-test",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Test",
            targets: ["Test"]
        ),
        .library(
            name: "Test Standard Library Integration",
            targets: ["Test Standard Library Integration"]
        ),
        .library(
            name: "Test Apple Foundation Integration",
            targets: ["Test Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-source.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-async.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-sequence.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-sample.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-numeric.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-witness.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-byte.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Test",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),
                .product(
                    name: "Tagged Standard Library Integration",
                    package: "swift-tagged"
                ),
                .product(name: "Source", package: "swift-source"),
                .product(name: "Sample", package: "swift-sample"),
                .product(name: "Real", package: "swift-numeric"),
                .product(name: "Async", package: "swift-async"),
                .product(
                    name: "Sequence Difference",
                    package: "swift-sequence"
                ),
                .product(name: "Witness", package: "swift-witness"),
                .product(name: "Byte", package: "swift-byte"),
                .product(
                    name: "Byte Standard Library Integration",
                    package: "swift-byte"
                ),
            ]
        ),
        .target(
            name: "Test Standard Library Integration",
            dependencies: ["Test"]
        ),
        .target(
            name: "Test Apple Foundation Integration",
            dependencies: [
                "Test",
                "Test Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Test Tests",
            dependencies: [
                "Test",
                .product(name: "Byte", package: "swift-byte"),
            ]
        ),
        .testTarget(
            name: "Test Standard Library Integration Tests",
            dependencies: [
                "Test",
                "Test Standard Library Integration",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
