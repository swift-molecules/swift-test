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
        .library(name: "Test", targets: ["Test"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-byte-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-source-primitives.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Test",
            dependencies: [
                .product(name: "Byte Primitives", package: "swift-byte-primitives"),
                .product(name: "Source Primitives", package: "swift-source-primitives"),
            ]
        ),
        .testTarget(
            name: "Test Tests",
            dependencies: [
                .target(name: "Test"),
                .product(name: "Source Primitives", package: "swift-source-primitives"),
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
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]
    let memberVisibility: [SwiftSetting] = target.name == "Test"
        ? [.enableUpcomingFeature("MemberImportVisibility")]
        : []
    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + memberVisibility
}
