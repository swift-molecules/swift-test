public import Byte
public import Witness

extension Test.Snapshot {

    public struct Diffing<Format>: Sendable, Witness.`Protocol` {

        public let toBytes: @Sendable (Format) -> [Byte]

        public let fromBytes: @Sendable ([Byte]) -> Format?

        public let diff: @Sendable (Format, Format) -> Diff.Result?

        public init(
            toBytes: @escaping @Sendable (Format) -> [Byte],
            fromBytes: @escaping @Sendable ([Byte]) -> Format?,
            diff: @escaping @Sendable (Format, Format) -> Diff.Result?
        ) {
            self.toBytes = toBytes
            self.fromBytes = fromBytes
            self.diff = diff
        }
    }
}
