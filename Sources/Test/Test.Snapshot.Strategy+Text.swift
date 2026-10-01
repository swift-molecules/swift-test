public import Byte
import Sequence

extension Test.Snapshot.Diffing where Format == String {

    public static var text: Self {
        Test.Snapshot.Diffing(
            toBytes: { $0.utf8.map(Byte.init(bitPattern:)) },
            fromBytes: { String(decoding: $0.map(\.bitPattern), as: UTF8.self) },
            diff: { old, new in
                guard old != new else { return nil }
                return Test.Snapshot.Diff.Result(summary: "Text content differs")
            }
        )
    }

    public static var lines: Self {
        Test.Snapshot.Diffing(
            toBytes: { $0.utf8.map(Byte.init(bitPattern:)) },
            fromBytes: { String(decoding: $0.map(\.bitPattern), as: UTF8.self) },
            diff: { old, new in
                guard old != new else { return nil }

                let oldLines = old.split(separator: "\n", omittingEmptySubsequences: false).map(
                    String.init
                )
                let newLines = new.split(separator: "\n", omittingEmptySubsequences: false).map(
                    String.init
                )

                let changes = Sequence.Difference.diff(oldLines, newLines)
                let (removed, added) = changes.counts()

                let summary: String
                if removed == .zero {
                    summary = "\(added) line\(added == .one ? "" : "s") added"
                } else if added == .zero {
                    summary = "\(removed) line\(removed == .one ? "" : "s") removed"
                } else {
                    summary =
                        "\(removed) line\(removed == .one ? "" : "s") removed, \(added) line\(added == .one ? "" : "s") added"
                }

                let styledDiff = Test.Snapshot.Diff.styled(oldLines, newLines)

                return Test.Snapshot.Diff.Result(
                    summary: summary,
                    unifiedDiff: styledDiff
                )
            }
        )
    }
}

extension Test.Snapshot.Strategy where Value == String, Format == String {

    public static var text: Self {
        Test.Snapshot.Strategy(pathExtension: "txt", diffing: .text)
    }

    public static var lines: Self {
        Test.Snapshot.Strategy(pathExtension: "txt", diffing: .lines)
    }
}
