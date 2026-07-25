# Test Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Test primitives for Swift — exhaustive three-valued-logic helpers (`Bool?` and `Bool` as `CaseIterable`), snapshot-test support, and standard-library test integration shared across the institute's packages. Foundation-free.

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-test-primitives.git", branch: "main")
]
```

Add the product to your target:

```swift
.target(
    name: "AppTests",
    dependencies: [
        .product(name: "Test Primitives", package: "swift-test-primitives")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
