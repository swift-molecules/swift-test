//
//  Test.Modifier.swift
//  swift-test-primitives
//
//  Statically composed, runner-neutral test scopes.
//

extension Test {
  /// A scoped operation applied by a relation package or external adapter.
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
  /// Composes two modifiers without existential erasure.
  public func followed<M: Test.Modifier>(by modifier: M) -> Test.ComposedModifier<Self, M> {
    .init(outer: self, inner: modifier)
  }
}

extension Test {
  /// Static composition of an outer and inner modifier.
  ///
  /// Swift 6.4 does not permit a concrete type declaration inside a protocol
  /// extension, so the composed value is owned directly by the `Test`
  /// namespace while retaining both concrete modifier types.
  public struct ComposedModifier<Outer: Test.Modifier, Inner: Test.Modifier>: Test.Modifier {
    public let outer: Outer
    public let inner: Inner

    public init(outer: Outer, inner: Inner) {
      self.outer = outer
      self.inner = inner
    }

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
}
