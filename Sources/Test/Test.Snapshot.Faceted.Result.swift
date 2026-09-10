extension Test.Snapshot.Faceted {

    public struct Result: Sendable {

        public let primary: Test.Snapshot.Result

        public let facets: [(name: Swift.String, result: Test.Snapshot.Result)]

        public init(
            primary: Test.Snapshot.Result,
            facets: [(name: Swift.String, result: Test.Snapshot.Result)]
        ) {
            self.primary = primary
            self.facets = facets
        }
    }
}

extension Test.Snapshot.Faceted.Result {

    public var isPassing: Bool {
        primary.isPassing && facets.allSatisfy { $0.result.isPassing }
    }

    public var isFailing: Bool {
        !isPassing
    }
}
