extension Test.Expression {

    public struct Value: Sendable, Hashable, Codable {

        public let label: String?

        public let stringValue: String

        public let typeDescription: String

        public let isNil: Bool

        public init(
            label: String? = nil,
            stringValue: String,
            typeDescription: String,
            isNil: Bool = false
        ) {
            self.label = label
            self.stringValue = stringValue
            self.typeDescription = typeDescription
            self.isNil = isNil
        }

        public init<T>(capturing value: T, label: String? = nil) {
            self.label = label
            self.stringValue = String(describing: value)
            self.typeDescription = String(describing: type(of: value))

            if let optional = value as? any OptionalProtocol {
                self.isNil = optional._isNil
            } else {
                self.isNil = false
            }
        }
    }
}

protocol OptionalProtocol {
    var _isNil: Bool { get }
}

extension Optional: OptionalProtocol {
    var _isNil: Bool {
        self == nil
    }
}

extension Test.Expression.Value: CustomStringConvertible {

    public var description: String {
        guard let label else { return stringValue }
        return "\(label) = \(stringValue)"
    }
}
