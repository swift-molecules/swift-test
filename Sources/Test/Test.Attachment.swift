public import Byte

extension Test {

    public struct Attachment: Sendable {

        public let name: Swift.String

        public let bytes: [Byte]

        public let contentType: Swift.String?

        public init(
            name: Swift.String,
            bytes: some Swift.Sequence<some Byte.`Protocol`>,
            contentType: Swift.String? = nil
        ) {
            self.name = name
            self.bytes = Swift.Array(bytes.lazy.map(\.byte))
            self.contentType = contentType
        }

        public init(name: Swift.String, string: Swift.String) {
            self.name = name
            self.bytes = string.utf8.map(Byte.init)
            self.contentType = "text/plain"
        }
    }
}
