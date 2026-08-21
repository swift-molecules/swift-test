// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

import Test

extension Trace {
    struct Modifier: NeutralTest.Modifier {
        let inheritance: NeutralTest.Scope.Inheritance
        let trace: Trace
        let name: String
    }
}

extension Trace.Modifier {
    func apply<R: ~Copyable & Sendable, E: Swift.Error>(
        in context: NeutralTest.Context,
        isolation: isolated (any Actor)?,
        operation: @isolated(any) () async throws(E) -> sending R
    ) async throws(E) -> sending R {
        trace.values.withLock { $0.append("\(name)-before") }
        let result = try await operation()
        trace.values.withLock { $0.append("\(name)-after") }
        return result
    }
}
