public import Source
extension Test {

    public struct Issue: Sendable, Hashable, Codable {

        public let kind: Kind

        public let sourceLocation: Source.Location?

        public let isKnown: Bool

        public let context: Test.Text?

        public init(
            kind: Kind,
            sourceLocation: Source.Location? = nil,
            isKnown: Bool = false,
            context: Test.Text? = nil
        ) {
            self.kind = kind
            self.sourceLocation = sourceLocation
            self.isKnown = isKnown
            self.context = context
        }
    }
}

extension Test.Issue: CustomStringConvertible {

    public var description: String {
        var result = kind.description

        if let sourceLocation {
            result += " at \(sourceLocation)"
        }

        if isKnown {
            result += " (known)"
        }

        if let context {
            result += ": \(context.plainText)"
        }

        return result
    }
}
