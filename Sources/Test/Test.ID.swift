extension Test {

    public struct ID: Sendable, Hashable, Codable {

        public let module: String

        public let suite: String?

        public let name: String

        public let sourceLocation: Source.Location

        public init(
            module: String,
            suite: String? = nil,
            name: String,
            sourceLocation: Source.Location
        ) {
            self.module = module
            self.suite = suite
            self.name = name
            self.sourceLocation = sourceLocation
        }
    }
}

extension Test.ID {

    public var fullyQualifiedName: String {
        guard let suite else { return "\(module).\(name)" }
        return "\(module).\(suite).\(name)"
    }
}

extension Test.ID: Comparable {

    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.module != rhs.module {
            return lhs.module < rhs.module
        }
        let lhsSuite = lhs.suite ?? ""
        let rhsSuite = rhs.suite ?? ""
        if lhsSuite != rhsSuite {
            return lhsSuite < rhsSuite
        }
        if lhs.name != rhs.name {
            return lhs.name < rhs.name
        }
        return lhs.sourceLocation < rhs.sourceLocation
    }
}

extension Test.ID: CustomStringConvertible {

    public var description: String {
        fullyQualifiedName
    }
}
