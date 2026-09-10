import Sample

extension Test.Benchmark.Complexity {

    public struct Exponent: Sendable, Hashable {

        public let value: Double

        public let coefficient: Double

        public let fit: Sample.Regression.Fit

        public init(
            value: Double,
            coefficient: Double,
            fit: Sample.Regression.Fit
        ) {
            self.value = value
            self.coefficient = coefficient
            self.fit = fit
        }
    }
}
