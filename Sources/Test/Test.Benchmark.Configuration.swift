extension Test.Benchmark {

    public struct Configuration: Sendable, Hashable, Codable {

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
