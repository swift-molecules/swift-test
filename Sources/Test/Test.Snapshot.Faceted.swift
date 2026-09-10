extension Test.Snapshot {

    public struct Faceted<Value> {

        public let primary: Strategy<Value, Swift.String>

        public let facets: [(name: Swift.String, strategy: Strategy<Value, Swift.String>)]

        public init(
            primary: Strategy<Value, Swift.String>,
            facets: [(name: Swift.String, strategy: Strategy<Value, Swift.String>)]
        ) {
            self.primary = primary
            self.facets = facets
        }
    }
}
