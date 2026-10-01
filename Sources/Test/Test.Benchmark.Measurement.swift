public import Sample

extension Test.Benchmark {

    public struct Measurement: Sendable {

        public let durations: [Duration]

        public let batch: Sample.Batch<Duration>

        public init(durations: [Duration]) {
            self.durations = durations
            self.batch = Sample.Batch(durations)
        }
    }
}

extension Test.Benchmark.Measurement {

    public var min: Duration {
        batch.min ?? .zero
    }

    public var max: Duration {
        batch.max ?? .zero
    }

    public var median: Duration {
        batch.median ?? .zero
    }

    public var mean: Duration {
        batch.mean(using: .duration) ?? .zero
    }

    public var p50: Duration {
        batch.p50 ?? .zero
    }

    public var p75: Duration {
        batch.p75 ?? .zero
    }

    public var p90: Duration {
        batch.p90 ?? .zero
    }

    public var p95: Duration {
        batch.p95 ?? .zero
    }

    public var p99: Duration {
        batch.p99 ?? .zero
    }

    public var p999: Duration {
        batch.p999 ?? .zero
    }

    public func percentile(_ p: Double) -> Duration {
        batch.percentile(p) ?? .zero
    }

    public var standardDeviation: Duration {
        batch.standardDeviation(using: .duration) ?? .zero
    }

    public var coefficientOfVariation: Double? {
        batch.coefficientOfVariation(using: .duration)
    }

    public var medianAbsoluteDeviation: Duration? {
        batch.medianAbsoluteDeviation
    }

    public func outlierCount(threshold k: Double = 3.0) -> Int? {
        batch.outlierCount(threshold: k)
    }
}

extension Test.Benchmark.Measurement: Codable {
    private enum CodingKeys: Swift.String, CodingKey {
        case durations
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(durations, forKey: .durations)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let durations = try container.decode([Duration].self, forKey: .durations)
        self.durations = durations
        self.batch = Sample.Batch(durations)
    }
}

extension Test.Benchmark.Measurement: Comparable {

    public static func < (
        lhs: Test.Benchmark.Measurement,
        rhs: Test.Benchmark.Measurement
    ) -> Bool {
        lhs.median < rhs.median
    }

    public static func == (
        lhs: Test.Benchmark.Measurement,
        rhs: Test.Benchmark.Measurement
    ) -> Bool {
        lhs.median == rhs.median
    }
}

extension Sample.Metric {

    @inlinable
    public func extract(from measurement: Test.Benchmark.Measurement) -> Duration {
        self.extract(from: measurement.batch, using: .duration) ?? .zero
    }
}
