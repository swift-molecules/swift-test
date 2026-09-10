import Synchronization

extension Test.Attachment {

    public final class Collector: @unsafe @unchecked Sendable {
        private let _storage = Mutex<[Test.Attachment]>([])

        public init() {}
    }

    public static let collector = Collector()
}

extension Test.Attachment.Collector {

    public func record(_ attachment: Test.Attachment) {
        _storage.withLock { $0.append(attachment) }
    }

    public func drain() -> [Test.Attachment] {
        _storage.withLock {
            let result = $0
            $0 = []
            return result
        }
    }

    public var isEmpty: Bool {
        _storage.withLock { $0.isEmpty }
    }
}
