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
        // MARK: - Sub-targets
        .library(name: "Test Core", targets: ["Test Core"]),
        .library(name: "Test Snapshot", targets: ["Test Snapshot"]),
        .library(
            name: "Test Standard Library Integration",
            targets: ["Test Standard Library Integration"]
        ),

        // MARK: - Umbrella
        .library(name: "Test", targets: ["Test"]),

        // MARK: - Test Support
        .library(
            name: "Test Test Support",
            targets: ["Test Test Support"]
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
            url: "https://github.com/swift-molecules/swift-time.git",
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
        // MARK: - Core
        .target(
            name: "Test Core",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Source", package: "swift-source"),
                .product(name: "Sample", package: "swift-sample"),
                .product(name: "Real", package: "swift-numeric"),
                .product(name: "Time", package: "swift-time"),
                .product(name: "Byte", package: "swift-byte"),
            ]
        ),

        // MARK: - Snapshot
        .target(
            name: "Test Snapshot",
            dependencies: [
                "Test Core",
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

        // MARK: - Standard Library Integration
        .target(
            name: "Test Standard Library Integration",
            dependencies: [
                "Test Core"
            ]
        ),

        // MARK: - Umbrella
        .target(
            name: "Test",
            dependencies: [
                "Test Core",
                "Test Snapshot",
                "Test Standard Library Integration",
            ]
        ),

        // MARK: - Test Support
        .target(
            name: "Test Test Support",
            dependencies: [
                "Test",
                .product(
                    name: "Tagged Test Support",
                    package: "swift-tagged"
                ),
            ],
            path: "Tests/Support"
        ),

        // MARK: - Tests
        .testTarget(
            name: "Test Tests",
            dependencies: [
                "Test",
                "Test Test Support",
                .product(name: "Byte", package: "swift-byte"),
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
