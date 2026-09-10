extension Test.Expectation {

    public struct Failure: Sendable, Hashable, Codable {

        public let message: Test.Text

        public let expected: Test.Expression.Value?

        public let actual: Test.Expression.Value?

        public let difference: Test.Text?

        public let comment: Test.Text?

        public init(
            message: Test.Text,
            expected: Test.Expression.Value? = nil,
            actual: Test.Expression.Value? = nil,
            difference: Test.Text? = nil,
            comment: Test.Text? = nil
        ) {
            self.message = message
            self.expected = expected
            self.actual = actual
            self.difference = difference
            self.comment = comment
        }
    }
}

extension Test.Expectation.Failure: CustomStringConvertible {

    public var description: String {
        var result = message.plainText

        if let expected, let actual {
            result += " (expected: \(expected.description), actual: \(actual.description))"
        }

        if let comment {
            result += " — \(comment.plainText)"
        }

        return result
    }
}
