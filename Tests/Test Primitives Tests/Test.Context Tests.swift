import Synchronization
import Test_Primitives
import Testing

private typealias NeutralTest = Test_Primitives.Test

private final class Trace: Sendable {
  let storage = Mutex<[String]>([])
}

private struct PassThroughModifier: NeutralTest.Modifier {
  let inheritance: NeutralTest.Scope.Inheritance
  let trace: Trace
  let label: String

  func apply<R: ~Copyable, E: Swift.Error>(
    in context: NeutralTest.Context,
    isolation: isolated (any Actor)?,
    operation: @isolated(any) () async throws(E) -> sending R
  ) async throws(E) -> sending R {
    trace.storage.withLock { $0.append("enter \(label)") }
    defer { trace.storage.withLock { $0.append("leave \(label)") } }
    return try await operation()
  }
}

private struct NoncopyableResult: ~Copyable {
  let value: Int
}

@Suite
struct `Test Context` {
  @Test
  func `recorder context reaches a structured child but not a detached task`() async {
    let trace = Trace()
    let context = NeutralTest.Context(
      recorder: .init { issue in trace.storage.withLock { $0.append(issue.description) } }
    )

    await context.withCurrent {
      await Task {
        NeutralTest.Context.current?.recorder(
          .init(kind: .system("child"))
        )
      }.value

      await Task.detached {
        #expect(NeutralTest.Context.current == nil)
      }.value
    }

    #expect(trace.storage.withLock { $0 }.count == 1)
  }

  @Test
  func `modifier composition preserves order and a noncopyable result`() async {
    let trace = Trace()
    let context = NeutralTest.Context(recorder: .init { _ in })
    let modifier = PassThroughModifier(
      inheritance: .local, trace: trace, label: "outer"
    ).followed(
      by: PassThroughModifier(inheritance: .recursive, trace: trace, label: "inner")
    )

    let result = await modifier.apply(in: context, isolation: #isolation) {
      trace.storage.withLock { $0.append("operation") }
      return NoncopyableResult(value: 42)
    }

    #expect(result.value == 42)
    #expect(modifier.inheritance == .recursive)
    #expect(
      trace.storage.withLock { $0 }
        == ["enter outer", "enter inner", "operation", "leave inner", "leave outer"]
    )
  }
}
