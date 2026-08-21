// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

public import Byte_Primitives

extension Test {
    /// A named diagnostic artifact carried without application reporting policy.
    public struct Attachment: Sendable, Hashable {
        public let name: String
        public let bytes: [Byte]
        public let format: String?

        public init(name: String, bytes: [Byte], format: String? = nil) {
            self.name = name
            self.bytes = bytes
            self.format = format
        }

        public init(name: String, text: String) {
            self.name = name
            self.bytes = text.utf8.map(Byte.init)
            self.format = "text/plain"
        }
    }
}

extension Test.Attachment {
    /// Projects the typed byte payload at an external API boundary that requires octets.
    public var octets: [UInt8] { bytes.map(\.underlying) }
}
