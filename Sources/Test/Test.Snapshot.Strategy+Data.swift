public import Byte

extension Test.Snapshot.Diffing where Format == [Byte] {

    public static var data: Self {
        Test.Snapshot.Diffing(
            toBytes: { $0 },
            fromBytes: { $0 },
            diff: { old, new in
                guard old != new else { return nil }

                var firstDiffOffset: Int?
                let minLength = min(old.count, new.count)

                for i in 0..<minLength {
                    if old[i] != new[i] {
                        firstDiffOffset = i
                        break
                    }
                }

                if firstDiffOffset == nil && old.count != new.count {
                    firstDiffOffset = minLength
                }

                let summary: String
                if old.count != new.count {
                    if let offset = firstDiffOffset {
                        summary =
                            "Binary data differs: expected \(old.count) bytes, got \(new.count) bytes (first difference at offset \(offset))"
                    } else {
                        summary =
                            "Binary data differs: expected \(old.count) bytes, got \(new.count) bytes"
                    }
                } else if let offset = firstDiffOffset {
                    summary = "Binary data differs at offset \(offset) (both \(old.count) bytes)"
                } else {
                    summary = "Binary data differs"
                }

                return Test.Snapshot.Diff.Result(summary: summary)
            }
        )
    }
}

extension Test.Snapshot.Strategy where Value == [Byte], Format == [Byte] {

    public static var data: Self {
        Test.Snapshot.Strategy(pathExtension: "bin", diffing: .data)
    }
}
