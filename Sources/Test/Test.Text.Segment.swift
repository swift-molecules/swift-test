// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

extension Test.Text {
    public struct Segment: Sendable, Hashable, Codable {
        public let content: String
        public let style: Style

        public init(_ content: String, style: Style) {
            self.content = content
            self.style = style
        }
    }
}
