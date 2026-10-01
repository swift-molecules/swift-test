public import Tagged
extension Test {

    public struct Event: Sendable, Codable {

        public let id: Test.ID?

        public let caseID: Test.Case.ID?

        public let kind: Kind

        public let elapsed: Duration?

        public let result: Result?

        public let testCase: Test.Case?

        public let reason: Test.Text?

        public let expectation: Test.Expectation?

        public let issue: Test.Issue?

        public let payload: Swift.String?

        public init(
            id: Test.ID? = nil,
            caseID: Test.Case.ID? = nil,
            kind: Kind,
            elapsed: Duration? = nil,
            result: Result? = nil,
            testCase: Test.Case? = nil,
            reason: Test.Text? = nil,
            expectation: Test.Expectation? = nil,
            issue: Test.Issue? = nil,
            payload: Swift.String? = nil
        ) {
            self.id = id
            self.caseID = caseID
            self.kind = kind
            self.elapsed = elapsed
            self.result = result
            self.testCase = testCase
            self.reason = reason
            self.expectation = expectation
            self.issue = issue
            self.payload = payload
        }
    }
}

extension Test.Event: CustomStringConvertible {

    public var description: String {
        var parts: [String] = []

        if let id {
            parts.append(id.description)
        }

        if let caseID {
            parts.append("case:\(caseID.underlying)")
        }

        parts.append(kind.description)

        if let result {
            parts.append("\(result)")
        }
        if let testCase {
            parts.append(testCase.arguments)
        }
        if let reason {
            parts.append(reason.plainText)
        }
        if let expectation {
            parts.append(expectation.isPassing ? "passed" : "failed")
        }
        if let issue {
            parts.append("\(issue.kind)")
        }

        if let payload {
            let truncated =
                payload.count > 64
                ? Swift.String(payload.prefix(64)) + "…"
                : payload
            parts.append("payload:\(truncated)")
        }

        if let elapsed {
            parts.append("@\(elapsed)")
        }

        return "Event(\(parts.joined(separator: ", ")))"
    }
}
