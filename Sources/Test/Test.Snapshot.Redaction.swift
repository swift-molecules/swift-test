extension Test.Snapshot {

    public struct Redaction<Format>: Sendable {

        public let apply: @Sendable (Format) -> Format

        public init(apply: @escaping @Sendable (Format) -> Format) {
            self.apply = apply
        }
    }
}
