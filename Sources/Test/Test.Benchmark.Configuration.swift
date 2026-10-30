extension Test.Benchmark {

    public struct Configuration: Sendable, Hashable {

        public var iteration: Iteration

        public var evaluation: Evaluation

        public init(
            iteration: Iteration = .init(),
            evaluation: Evaluation = .init()
        ) {
            self.iteration = iteration
            self.evaluation = evaluation
        }
    }
}

#if !hasFeature(Embedded)
    extension Test.Benchmark.Configuration: Codable {}
#endif
