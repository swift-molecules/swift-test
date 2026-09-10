extension Test.Snapshot.Diff {

    public struct Result: Sendable, Hashable, Codable {

        public let summary: String

        public let unifiedDiff: Test.Text?

        public let structuralOperations: [Operation]?

        public init(
            summary: String,
            unifiedDiff: Test.Text? = nil,
            structuralOperations: [Operation]? = nil
        ) {
            self.summary = summary
            self.unifiedDiff = unifiedDiff
            self.structuralOperations = structuralOperations
        }
    }
}

extension Test.Snapshot.Diff.Result: CustomStringConvertible {

    public var description: String {
        if let diff = unifiedDiff {
            return "\(summary)\n\(diff.plainText)"
        }
        return summary
    }
}
