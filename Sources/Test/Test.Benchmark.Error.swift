extension Test.Benchmark {

    public enum Error: Swift.Error, Sendable, CustomStringConvertible {

        case thresholdExceeded(
            test: Swift.String,
            metric: Metric,
            expected: Duration,
            actual: Duration
        )

        case regressionDetected(
            test: Swift.String,
            metric: Metric,
            baseline: Duration,
            current: Duration,
            regression: Double,
            tolerance: Double
        )
    }
}

extension Test.Benchmark.Error {

    public var description: Swift.String {
        switch self {
        case .thresholdExceeded(let test, let metric, let expected, let actual):
            return """
                Performance threshold exceeded in '\(test)':
                Expected \(metric): < \(expected.formatted())
                Actual \(metric): \(actual.formatted())
                """

        case .regressionDetected(
            let test,
            let metric,
            let baseline,
            let current,
            let regression,
            let tolerance
        ):
            return """
                Performance regression detected in '\(test)':
                Baseline \(metric): \(baseline.formatted())
                Current \(metric): \(current.formatted())
                Regression: \(regression)x tolerance (\(tolerance))
                """
        }
    }
}
