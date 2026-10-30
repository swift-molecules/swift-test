public import Source
public import Tagged

extension Test {

    public struct Expression: Sendable, Hashable {

        public let id: ID

        public let sourceCode: String

        public let sourceLocation: Source.Location

        public let values: [Value]

        public init(
            id: ID,
            sourceCode: String,
            sourceLocation: Source.Location,
            values: [Value] = []
        ) {
            self.id = id
            self.sourceCode = sourceCode
            self.sourceLocation = sourceLocation
            self.values = values
        }
    }
}

extension Test.Expression {

    public typealias ID = Tagged<Test.Expression, UInt64>
}

extension Test.Expression: CustomStringConvertible {

    public var description: String {
        sourceCode
    }
}

#if !hasFeature(Embedded)
    extension Test.Expression: Codable {}
#endif
