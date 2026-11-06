public import Byte
public import Carrier

extension Test {

    public struct Attachment: Sendable {

        public let name: Swift::String

        public let bytes: [Byte]

        // swift-linter:disable:next raw concept
        // REASON: RFC_9110.MediaType owns this and sits in swift-standards, above this molecule; the value stays text at this tier.
        public let contentType: Swift::String?

        public init<Bytes: Swift::Sequence>(
            name: Swift::String,
            bytes: Bytes,
            // swift-linter:disable:next raw concept
            // REASON: RFC_9110.MediaType owns this and sits in swift-standards, above this molecule; the value stays text at this tier.
            contentType: Swift::String? = nil
        ) where Bytes.Element: Carrier.`Protocol`, Bytes.Element.Underlying == UInt8 {
            self.name = name
            self.bytes = Swift::Array(bytes.lazy.map { Byte(bitPattern: $0.underlying) })
            self.contentType = contentType
        }

        public init(name: Swift::String, string: Swift::String) {
            self.name = name
            self.bytes = string.utf8.map(Byte.init(bitPattern:))
            self.contentType = "text/plain"
        }
    }
}
