extension Test.Benchmark {

    public struct Trend: Sendable {

        public let z: Double

        public let interpretation: Interpretation

        public init(z: Double, interpretation: Interpretation) {
            self.z = z
            self.interpretation = interpretation
        }
    }
}

extension Test.Benchmark.Trend {

    public struct Interpretation: Sendable, Codable, Hashable, CustomStringConvertible {

        public let rawValue: Swift.String

        public init(rawValue: Swift.String) {
            self.rawValue = rawValue
        }
    }
}

extension Test.Benchmark.Trend.Interpretation {

    public static let increasing = Self(rawValue: "increasing")

    public static let decreasing = Self(rawValue: "decreasing")

    public static let none = Self(rawValue: "none")

    public var description: Swift.String { rawValue }
}
