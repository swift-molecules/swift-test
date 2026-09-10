extension Test {

    public struct Text: Sendable, Hashable, Codable {

        public let segments: [Segment]

        public init(_ segments: [Segment]) {
            self.segments = segments
        }

        public init(_ string: String) {
            self.segments = [Segment(string, style: .plain)]
        }
    }
}

extension Test.Text {

    public var plainText: String {
        segments.map(\.content).joined()
    }

    public var isEmpty: Bool {
        segments.allSatisfy { $0.content.isEmpty }
    }
}

extension Test.Text: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension Test.Text: ExpressibleByStringInterpolation {

    public init(stringInterpolation: DefaultStringInterpolation) {

        self.init(String(stringInterpolation: stringInterpolation))
    }
}

extension Test.Text: ExpressibleByArrayLiteral {

    public init(arrayLiteral elements: Segment...) {
        self.init(elements)
    }
}

extension Test.Text: CustomStringConvertible {

    public var description: String {
        plainText
    }
}

extension Test.Text {

    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.segments + rhs.segments)
    }

    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
}
