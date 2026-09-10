import Sample

extension Test.Benchmark.Complexity.Candidate {

    public struct Fit: Sendable, Hashable {

        public let complexity: Test.Benchmark.Complexity.Class

        public let regression: Sample.Regression.Fit

        public let effectiveExponent: Double

        public init(
            complexity: Test.Benchmark.Complexity.Class,
            regression: Sample.Regression.Fit,
            effectiveExponent: Double
        ) {
            self.complexity = complexity
            self.regression = regression
            self.effectiveExponent = effectiveExponent
        }
    }
}
