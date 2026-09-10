extension Test.Text {

    public struct Segment: Sendable, Hashable, Codable {

        public let content: String

        public let style: Style

        public init(_ content: String, style: Style) {
            self.content = content
            self.style = style
        }
    }
}

extension Test.Text.Segment {

    public enum Style: String, Sendable, Hashable, Codable, CaseIterable {

        case plain

        case identifier

        case value

        case keyword

        case punctuation

        case emphasis

        case secondary

        case success

        case failure

        case warning

        case diffAdded

        case diffRemoved

        case diffContext
    }
}

extension Test.Text.Segment: CustomStringConvertible {

    public var description: String {
        content
    }
}

extension Test.Text.Segment: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value, style: .plain)
    }
}
