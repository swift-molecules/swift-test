extension Test.Benchmark {

    public struct Evaluation: Sendable, Hashable, Codable {

        public var threshold: Duration?

        public var metric: Metric

        public var baselineTolerance: Double?

        public var trackAllocations: Bool

        public var printResults: Bool

        public init(
            threshold: Duration? = nil,
            metric: Metric = .median,
            baselineTolerance: Double? = nil,
            trackAllocations: Bool = false,
            printResults: Bool = true
        ) {
            self.threshold = threshold
            self.metric = metric
            self.baselineTolerance = baselineTolerance
            self.trackAllocations = trackAllocations
            self.printResults = printResults
        }
    }
}
