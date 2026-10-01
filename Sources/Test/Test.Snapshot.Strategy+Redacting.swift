public import Async
extension Test.Snapshot.Strategy {

    public func redacting(
        _ redactions: [Test.Snapshot.Redaction<Format>]
    ) -> Self {
        guard !redactions.isEmpty else { return self }

        let redact: (Format) -> Format = { format in
            redactions.reduce(format) { result, redaction in
                redaction.apply(result)
            }
        }

        let capturedSnapshot = self.snapshot

        return Self(
            pathExtension: pathExtension,
            diffing: diffing,
            syncSnapshot: syncSnapshot.map { sync in
                { value in redact(sync(value)) }
            },
            asyncSnapshot: { value in
                Async.Callback {
                    redact(await capturedSnapshot(value)())
                }
            }
        )
    }

    public func redacting(
        _ redaction: Test.Snapshot.Redaction<Format>
    ) -> Self {
        redacting([redaction])
    }
}
