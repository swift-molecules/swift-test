extension Test.Benchmark {

    public struct Iteration: Sendable, Hashable, Codable {

        public var count: Int

        public var warmup: Int

        public init(
            count: Int = 10,
            warmup: Int = 0
        ) {
            self.count = count
            self.warmup = warmup
        }
    }
}
