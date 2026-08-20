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
  public func withCurrent<R, E: Swift.Error>(
    operation: () throws(E) -> R
  ) throws(E) -> R {
    do {
      return try Self.$current.withValue(self, operation: operation)
    } catch let error as E {
      throw error
    } catch {
      preconditionFailure("TaskLocal.withValue introduced an unexpected error type")
    }
  }

  /// Runs an asynchronous operation with this context as the current context.
  public func withCurrent<R, E: Swift.Error>(
    operation: () async throws(E) -> R
  ) async throws(E) -> R {
    do {
      return try await Self.$current.withValue(self, operation: operation)
    } catch let error as E {
      throw error
    } catch {
      preconditionFailure("TaskLocal.withValue introduced an unexpected error type")
    }
  }
}
