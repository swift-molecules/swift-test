//
//  Test.Scope.swift
//  swift-test-primitives
//
//  Runner-neutral modifier scope vocabulary.
//

extension Test {
  /// Namespace for modifier scope policy.
  public enum Scope {}
}

extension Test.Scope {
  /// Whether a modifier applies only to one test or to nested tests as well.
  public enum Inheritance: Sendable {
    case local
    case recursive
  }
}
