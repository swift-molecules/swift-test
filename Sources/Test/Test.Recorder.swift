// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

extension Test {
    /// An explicit sendable destination for neutral issues and attachments.
    public struct Recorder: Sendable {
        private let issue: @Sendable (Issue) -> Void
        private let attachment: @Sendable (Attachment) -> Void

        public init(
            issue: @escaping @Sendable (Issue) -> Void,
            attachment: @escaping @Sendable (Attachment) -> Void = { _ in }
        ) {
            self.issue = issue
            self.attachment = attachment
        }
    }
}

extension Test.Recorder {
    public func callAsFunction(_ issue: Test.Issue) { self.issue(issue) }
    public func record(_ attachment: Test.Attachment) { self.attachment(attachment) }
}
