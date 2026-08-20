// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

extension Test {
    public struct Composition<Outer: Test.Modifier, Inner: Test.Modifier>: Test.Modifier {
        public let outer: Outer
        public let inner: Inner

        public init(outer: Outer, inner: Inner) {
            self.outer = outer
            self.inner = inner
        }
    }
}

extension Test.Composition {
    public var inheritance: Test.Scope.Inheritance {
        switch (outer.inheritance, inner.inheritance) {
        case (.recursive, _), (_, .recursive): .recursive
        case (.local, .local): .local
        }
    }

    public func apply<R: ~Copyable, E: Swift.Error>(
        in context: Test.Context,
        isolation: isolated (any Actor)?,
        operation: @isolated(any) () async throws(E) -> sending R
    ) async throws(E) -> sending R {
        try await outer.apply(
            in: context,
            isolation: isolation,
            operation: { () async throws(E) -> sending R in
                try await inner.apply(
                    in: context,
                    isolation: isolation,
                    operation: operation
                )
            }
        )
    }
}
