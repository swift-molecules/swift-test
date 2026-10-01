public import Source_Standard_Library_Integration
public import Sample
public import Source
extension Test {

    public struct Trait: Sendable, Hashable, Codable {

        public let kind: Kind

        public let sourceLocation: Source.Location?

        public init(
            kind: Kind,
            sourceLocation: Source.Location? = nil
        ) {
            self.kind = kind
            self.sourceLocation = sourceLocation
        }
    }
}

extension Test.Trait {

    public static func timeLimit(_ duration: Duration) -> Self {
        Self(kind: .timeLimit(duration))
    }

    public static func tag(_ name: String) -> Self {
        Self(kind: .tag(name))
    }

    public static func enabled(if condition: Bool, _ comment: Test.Text? = nil) -> Self {
        Self(kind: .enabled(condition, comment))
    }

    public static func disabled(_ comment: Test.Text? = nil) -> Self {
        Self(kind: .enabled(false, comment))
    }

    public static func bug(_ id: String, _ comment: Test.Text? = nil) -> Self {
        Self(kind: .bug(id, comment))
    }

    public static var serialized: Self {
        Self(kind: .serialized)
    }

    public static var exclusive: Self {
        exclusive(group: "__global__")
    }

    public static func exclusive(group: String) -> Self {
        Self(kind: .exclusive(group))
    }

    public static func timed(
        iterations: Int = 10,
        warmup: Int = 0,
        threshold: Duration? = nil,
        metric: Test.Benchmark.Metric = .median,
        baselineTolerance: Double? = nil,
        trackAllocations: Bool = false
    ) -> Self {
        Self(
            kind: .timed(
                .init(
                    iteration: .init(count: iterations, warmup: warmup),
                    evaluation: .init(
                        threshold: threshold,
                        metric: metric,
                        baselineTolerance: baselineTolerance,
                        trackAllocations: trackAllocations
                    )
                )
            )
        )
    }
}

extension Test.Trait: CustomStringConvertible {

    public var description: String {
        kind.description
    }
}
