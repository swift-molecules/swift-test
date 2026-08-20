// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

extension Test {
    /// A generic runner-neutral scoped operation supplied by a relation or adapter.
    public protocol Modifier: Sendable {
        var inheritance: Test.Scope.Inheritance { get }

        func apply<R: ~Copyable, E: Swift.Error>(
            in context: Test.Context,
            isolation: isolated (any Actor)?,
            operation: @isolated(any) () async throws(E) -> sending R
        ) async throws(E) -> sending R
    }
}

extension Test.Modifier {
    public func followed<M: Test.Modifier>(
        by modifier: M
    ) -> Test.Composition<Self, M> {
        .init(outer: self, inner: modifier)
    }
}
