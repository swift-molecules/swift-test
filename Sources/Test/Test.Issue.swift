// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

public import Source_Primitives

extension Test {
    /// A framework-independent problem recorded while evaluating test-related policy.
    public struct Issue: Sendable, Hashable, Codable {
        public let kind: Kind
        public let message: Text
        public let source: Source.Location?
        public let isKnown: Bool

        public init(
            kind: Kind,
            message: Text,
            source: Source.Location? = nil,
            isKnown: Bool = false
        ) {
            self.kind = kind
            self.message = message
            self.source = source
            self.isKnown = isKnown
        }
    }
}

extension Test.Issue: CustomStringConvertible {
    public var description: String {
        var value = "\(kind): \(message.plain)"
        if let source { value += " at \(source)" }
        if isKnown { value += " (known)" }
        return value
    }
}
