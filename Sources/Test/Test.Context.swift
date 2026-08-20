// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

public import Source_Primitives

extension Test {
    /// Test identity and recording capability inherited by structured child tasks.
    public struct Context: Sendable {
        public let id: Test.ID?
        public let source: Source.Location?
        public let recorder: Test.Recorder

        public init(
            id: Test.ID? = nil,
            source: Source.Location? = nil,
            recorder: Test.Recorder
        ) {
            self.id = id
            self.source = source
            self.recorder = recorder
        }
    }
}

extension Test.Context {
    @TaskLocal public static var current: Test.Context?

    public func with<R: ~Copyable, E: Swift.Error>(
        operation: () throws(E) -> R
    ) throws(E) -> R {
        var result: R?
        // swift-linter:disable:next do throws for typed catch
        // REASON: TaskLocal.withValue currently exposes untyped rethrows across this boundary.
        do {
            try Self.$current.withValue(self) { () throws(E) in
                result = try operation()
            }
        } catch let error as E {
            throw error
        } catch {
            preconditionFailure("TaskLocal.withValue introduced an unexpected error type")
        }
        guard let result = consume result else {
            preconditionFailure("TaskLocal.withValue did not invoke its operation")
        }
        return result
    }

    public func with<R: ~Copyable, E: Swift.Error>(
        operation: () async throws(E) -> R
    ) async throws(E) -> R {
        var result: R?
        // swift-linter:disable:next do throws for typed catch
        // REASON: TaskLocal.withValue currently exposes untyped rethrows across this boundary.
        do {
            try await Self.$current.withValue(self) { () async throws(E) in
                result = try await operation()
            }
        } catch let error as E {
            throw error
        } catch {
            preconditionFailure("TaskLocal.withValue introduced an unexpected error type")
        }
        guard let result = consume result else {
            preconditionFailure("TaskLocal.withValue did not invoke its operation")
        }
        return result
    }
}
