// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

import Synchronization
import Testing

@Suite
struct `Test Tests` {
    @Suite
    struct Unit {
        @Test
        func `identity and outcome remain runner neutral`() {
            let source = source()
            let id = identity(source: source)
            let issue = NeutralTest.Issue(kind: .assertion, message: "mismatch", source: source)

            #expect(id.qualified == "ExampleTests.Feature.works")
            #expect(NeutralTest.Outcome.failed(issues: [issue]) != .passed)
            #expect(issue.description.contains("mismatch"))
        }

        @Test
        func `recorder carries issues and attachments explicitly`() {
            let issues = Mutex<[NeutralTest.Issue]>([])
            let attachments = Mutex<[NeutralTest.Attachment]>([])
            let recorder = NeutralTest.Recorder(
                issue: { issue in issues.withLock { $0.append(issue) } },
                attachment: { attachment in attachments.withLock { $0.append(attachment) } }
            )

            recorder(.init(kind: .assertion, message: "different"))
            recorder.record(.init(name: "difference.txt", text: "- old\n+ new"))

            #expect(issues.withLock { $0.count } == 1)
            #expect(attachments.withLock { $0.first?.format } == "text/plain")
            #expect(attachments.withLock { $0.first?.octets } == Array("- old\n+ new".utf8))
        }
    }

    @Suite
    struct `Edge Case` {
        @Test
        func `context preserves a noncopyable result`() throws {
            struct Token: ~Copyable { let value: Int }
            let context = NeutralTest.Context(recorder: .init(issue: { _ in }))
            let token = context.with { Token(value: 42) }

            #expect(token.value == 42)
            #expect(NeutralTest.Context.current == nil)
        }
    }

    @Suite
    struct Integration {
        @Test
        func `modifier preserves a noncopyable result`() async {
            struct Token: ~Copyable { let value: Int }
            let trace = Trace()
            let context = NeutralTest.Context(recorder: .init(issue: { _ in }))
            let modifier = Trace.Modifier(inheritance: .local, trace: trace, name: "scope")

            let token = await modifier.apply(in: context, isolation: nil) {
                Token(value: 42)
            }

            #expect(token.value == 42)
            #expect(trace.values.withLock { $0 } == ["scope-before", "scope-after"])
        }

        @Test
        func `default test body scope invokes its operation exactly once`() async {
            let trace = Trace()
            let context = NeutralTest.Context(recorder: .init(issue: { _ in }))
            let modifier = Trace.Modifier(inheritance: .local, trace: trace, name: "scope")

            await modifier.scope(in: context, isolation: nil) {
                trace.values.withLock { $0.append("operation") }
            }

            #expect(trace.values.withLock { $0 } == ["scope-before", "operation", "scope-after"])
        }

        @Test
        func `static modifiers compose in deterministic scope order`() async {
            let trace = Trace()
            let context = NeutralTest.Context(recorder: .init(issue: { _ in }))
            let modifier = Trace.Modifier(inheritance: .local, trace: trace, name: "outer")
                .followed(by: Trace.Modifier(inheritance: .recursive, trace: trace, name: "inner"))

            let value = await modifier.apply(in: context, isolation: nil) {
                trace.values.withLock { $0.append("operation") }
                return 42
            }

            #expect(value == 42)
            #expect(trace.values.withLock { $0 } == ["outer-before", "inner-before", "operation", "inner-after", "outer-after"])
            #expect(modifier.inheritance == .recursive)
        }
    }
}
