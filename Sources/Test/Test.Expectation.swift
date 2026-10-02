public import Tagged
extension Test {

    public struct Expectation: Sendable, Hashable, Codable {

        public let id: ID

        public let expression: Test.Expression

        public let isPassing: Bool

        public let failure: Failure?

        public init(
            id: ID,
            expression: Test.Expression,
            isPassing: Bool,
            failure: Failure? = nil
        ) {
            precondition(
                !isPassing || failure == nil,
                "Passing expectation must not have a failure"
            )
            precondition(
                isPassing || failure != nil,
                "Failing expectation must have a failure reason"
            )
            self.id = id
            self.expression = expression
            self.isPassing = isPassing
            self.failure = failure
        }
    }
}

extension Test.Expectation {

    public var isFailing: Bool {
        !isPassing
    }
}

extension Test.Expectation {

    public typealias ID = Tagged<Test.Expectation, UInt64>
}

extension Test.Expectation: CustomStringConvertible {

    public var description: String {
        guard let failure else { return "✓ \(expression.sourceCode)" }
        return "✗ \(expression.sourceCode): \(failure.message)"
    }
}

extension Test.Expectation {

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let isPassing = try container.decode(Bool.self, forKey: .isPassing)
        let failure = try container.decodeIfPresent(Failure.self, forKey: .failure)
        guard isPassing == (failure == nil) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: isPassing
                        ? "Passing expectation must not have a failure"
                        : "Failing expectation must have a failure reason"
                )
            )
        }
        self.init(
            id: try container.decode(ID.self, forKey: .id),
            expression: try container.decode(Test.Expression.self, forKey: .expression),
            isPassing: isPassing,
            failure: failure
        )
    }
}
