// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

extension Test.Text.Segment {
    public enum Style: String, Sendable, Hashable, Codable, CaseIterable {
        case plain
        case identifier
        case value
        case emphasis
        case secondary
        case success
        case failure
        case warning
        case differenceAdded
        case differenceRemoved
        case differenceContext
    }
}
