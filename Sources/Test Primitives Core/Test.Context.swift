//
//  Test.Context.swift
//  swift-test-primitives
//
//  Scoped neutral test identity and recording context.
//

extension Test {
  /// Test information propagated through structured concurrency.
  public struct Context: Sendable {
    public let id: Test.ID?
    public let source: Source.Location?
    public let recorder: Test.Recorder

    /// Creates a scoped test context.
    public init(
      id: Test.ID? = nil,
      source: Source.Location? = nil,
      recorder: Test.Recorder
    ) {
      self.id = id
      self.source = source
      self.recorder = recorder
    }

    /// The context inherited by structured child tasks.
    @TaskLocal public static var current: Test.Context?
  }
}

extension Test.Context {
  /// Runs an operation with this context as the current context.
  // swiftlint:disable typed_throws_required
  // Reason: TaskLocal.withValue currently exposes untyped throws upstream.
  public func withCurrent<R>(
    operation: () throws -> R
  ) rethrows -> R {
    try Self.$current.withValue(self, operation: operation)
  }

  /// Runs an asynchronous operation with this context as the current context.
  public func withCurrent<R>(
    operation: () async throws -> R
  ) async rethrows -> R {
    try await Self.$current.withValue(self, operation: operation)
  }
  // swiftlint:enable typed_throws_required
}
