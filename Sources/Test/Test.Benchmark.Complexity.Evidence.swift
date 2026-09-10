extension Test.Benchmark.Complexity {

    public struct Evidence: Sendable {

        public let exponent: Exponent

        public let candidates: [Candidate.Fit]

        public let growthRatios: [Double]

        public let monotonicity: Test.Benchmark.Trend

        public let points: [(size: Int, metric: Duration)]

        public let metricCV: Double

        public init(
            exponent: Exponent,
            candidates: [Candidate.Fit],
            growthRatios: [Double],
            monotonicity: Test.Benchmark.Trend,
            points: [(size: Int, metric: Duration)],
            metricCV: Double
        ) {
            self.exponent = exponent
            self.candidates = candidates
            self.growthRatios = growthRatios
            self.monotonicity = monotonicity
            self.points = points
            self.metricCV = metricCV
        }
    }
}
