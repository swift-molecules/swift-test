// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

extension Test {
    /// Structured diagnostic text whose styles describe meaning rather than presentation.
    public struct Text: Sendable, Hashable, Codable {
        public let segments: [Segment]

        public init(_ segments: [Segment]) {
            self.segments = segments
        }

        public init(_ string: String) {
            self.segments = [.init(string, style: .plain)]
        }
    }
}

extension Test.Text {
    public var plain: String { segments.map(\.content).joined() }
    public var isEmpty: Bool { segments.allSatisfy { $0.content.isEmpty } }
}

extension Test.Text: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self.init(value) }
}

extension Test.Text: ExpressibleByStringInterpolation {
    public init(stringInterpolation: DefaultStringInterpolation) {
        self.init(String(stringInterpolation: stringInterpolation))
    }
}

extension Test.Text: CustomStringConvertible {
    public var description: String { plain }
}
