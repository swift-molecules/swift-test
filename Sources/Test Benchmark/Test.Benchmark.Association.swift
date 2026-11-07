// swift-linter:disable:next target import edge
// REASON: Source Primitives is a direct product dependency; the Benchmark module alias currently prevents the manifest scanner from recognizing later edges.
public import Source
public import Test

extension Test.Benchmark {
    public struct Association: Sendable, Hashable {
        public let name: Swift.String
        public let source: Source.Location

        public init(name: consuming Swift.String, source: Source.Location) {
            self.name = name
            self.source = source
        }
    }
}
