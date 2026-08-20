// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

extension Test.Issue {
    public enum Kind: String, Sendable, Hashable, Codable, CaseIterable {
        case assertion
        case error
        case timeout
        case misuse
        case system
    }
}
