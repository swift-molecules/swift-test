public import Witness

extension Test.Snapshot {

    public struct Strategy<Value, Format>: Witness.`Protocol` where Format: Sendable {

        public var pathExtension: String?

        public var diffing: Diffing<Format>

        public var snapshot: (Value) -> Async.Callback<Format>

        public var syncSnapshot: ((Value) -> Format)?

        public init(
            pathExtension: String?,
            diffing: Diffing<Format>,
            asyncSnapshot: @escaping (_ value: Value) -> Async.Callback<Format>
        ) {
            self.pathExtension = pathExtension
            self.diffing = diffing
            self.snapshot = asyncSnapshot
            self.syncSnapshot = nil
        }

        public init(
            pathExtension: String?,
            diffing: Diffing<Format>,
            snapshot: @escaping (_ value: Value) -> Format
        ) {
            self.pathExtension = pathExtension
            self.diffing = diffing
            self.syncSnapshot = snapshot
            self.snapshot = { value in Async.Callback(value: snapshot(value)) }
        }

        init(
            pathExtension: String?,
            diffing: Diffing<Format>,
            syncSnapshot: ((Value) -> Format)?,
            asyncSnapshot: @escaping (Value) -> Async.Callback<Format>
        ) {
            self.pathExtension = pathExtension
            self.diffing = diffing
            self.syncSnapshot = syncSnapshot
            self.snapshot = asyncSnapshot
        }

        public func pullback<NewValue>(
            _ transform: @escaping (_ otherValue: NewValue) -> Value
        ) -> Test.Snapshot.Strategy<NewValue, Format> {
            let capturedSnapshot = self.snapshot
            let capturedSyncSnapshot = self.syncSnapshot

            var newSyncSnapshot: ((NewValue) -> Format)?
            if let sync = capturedSyncSnapshot {
                newSyncSnapshot = { newValue in sync(transform(newValue)) }
            }

            return Test.Snapshot.Strategy<NewValue, Format>(
                pathExtension: pathExtension,
                diffing: diffing,
                syncSnapshot: newSyncSnapshot,
                asyncSnapshot: { newValue in
                    capturedSnapshot(transform(newValue))
                }
            )
        }

        public func asyncPullback<NewValue>(
            _ transform: @escaping (_ otherValue: NewValue) -> Async.Callback<Value>
        ) -> Test.Snapshot.Strategy<NewValue, Format> {
            let capturedSnapshot = self.snapshot
            return Test.Snapshot.Strategy<NewValue, Format>(
                pathExtension: pathExtension,
                diffing: diffing,
                asyncSnapshot: { newValue in
                    Async.Callback {
                        await capturedSnapshot(await transform(newValue)())()
                    }
                }
            )
        }

        public func capture(_ value: Value) async -> Format {
            await snapshot(value)()
        }

        public var isSynchronous: Bool {
            syncSnapshot != nil
        }
    }
}

extension Test.Snapshot {

    public typealias SimplyStrategy<Format> = Strategy<Format, Format>
}

extension Test.Snapshot.Strategy where Value == Format {

    public init(pathExtension: String?, diffing: Test.Snapshot.Diffing<Format>) {
        self.init(
            pathExtension: pathExtension,
            diffing: diffing,
            snapshot: { $0 }
        )
    }
}
