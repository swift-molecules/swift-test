extension Test {

    public struct Case: Sendable, Hashable, Codable {

        public let id: ID

        public let arguments: String

        public init(id: ID, arguments: String) {
            self.id = id
            self.arguments = arguments
        }
    }
}

extension Test.Case {

    public typealias ID = Tagged<Test.Case, UInt64>
}

extension Test.Case: CustomStringConvertible {

    public var description: String {
        "Case(\(arguments))"
    }
}
