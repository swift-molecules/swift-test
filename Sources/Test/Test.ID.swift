// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

public import Source_Primitives

extension Test {
    /// A stable semantic test identity independent of a runner's runtime identifier.
    public struct ID: Sendable, Hashable, Codable {
        public let module: String
        public let suite: String?
        public let name: String
        public let source: Source.Location

        public init(
            module: String,
            suite: String? = nil,
            name: String,
            source: Source.Location
        ) {
            self.module = module
            self.suite = suite
            self.name = name
            self.source = source
        }
    }
}

extension Test.ID {
    public var qualified: String {
        [module, suite, name].compactMap { $0 }.joined(separator: ".")
    }
}

extension Test.ID: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.module != rhs.module { return lhs.module < rhs.module }
        if lhs.suite != rhs.suite { return (lhs.suite ?? "") < (rhs.suite ?? "") }
        if lhs.name != rhs.name { return lhs.name < rhs.name }
        return lhs.source.description < rhs.source.description
    }
}

extension Test.ID: CustomStringConvertible {
    public var description: String { qualified }
}
