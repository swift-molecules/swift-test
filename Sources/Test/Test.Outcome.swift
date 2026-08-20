// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

extension Test {
    /// A runner-neutral terminal outcome.
    public enum Outcome: Sendable, Hashable, Codable {
        case passed
        case failed(issues: [Issue])
        case skipped(reason: Text?)
    }
}
