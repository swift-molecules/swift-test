//
//  Test.Recorder.swift
//  swift-test-primitives
//
//  Explicit issue recording without process-global state.
//

extension Test {
  /// A sendable destination for neutral test issues.
  public struct Recorder: Sendable {
    private let recordIssue: @Sendable (Test.Issue) -> Void

    /// Creates a recorder backed by the supplied operation.
    public init(_ recordIssue: @escaping @Sendable (Test.Issue) -> Void) {
      self.recordIssue = recordIssue
    }

    /// Records an issue.
    public func callAsFunction(_ issue: Test.Issue) {
      recordIssue(issue)
    }
  }
}
