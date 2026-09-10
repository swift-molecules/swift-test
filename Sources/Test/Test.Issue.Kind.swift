extension Test.Issue {

    public enum Kind: Sendable, Hashable, Codable {

        case unconditional(Test.Text)

        case expectationFailed(Test.Expectation.ID)

        case confirmationMiscounted(actual: Int, expected: Int)

        case errorCaught(type: String, description: Test.Text)

        case timeLimitExceeded(limit: Duration)

        case knownIssueNotRecorded

        case apiMisused(Test.Text)

        case system(Test.Text)
    }
}

extension Test.Issue.Kind: CustomStringConvertible {

    public var description: String {
        switch self {
        case .unconditional(let message):
            return "Unconditional failure: \(message.plainText)"

        case .expectationFailed(let id):
            return "Expectation failed (id: \(id.underlying))"

        case .confirmationMiscounted(let actual, let expected):
            return "Confirmation miscounted: expected \(expected), got \(actual)"

        case .errorCaught(let type, let description):
            return "Error caught (\(type)): \(description.plainText)"

        case .timeLimitExceeded(let limit):
            return "Time limit exceeded: \(limit)"

        case .knownIssueNotRecorded:
            return "Known issue was not recorded"

        case .apiMisused(let message):
            return "API misuse: \(message.plainText)"

        case .system(let message):
            return "System error: \(message.plainText)"
        }
    }
}
