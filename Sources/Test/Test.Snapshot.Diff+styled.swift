extension Test.Snapshot.Diff {

    public static func styled(
        _ old: [String],
        _ new: [String],
        contextLines: Cardinal = 3
    ) -> Test.Text {
        let changes = Sequence.Difference.diff(old, new)
        let (removed, inserted) = changes.counts()

        guard removed > .zero || inserted > .zero else {
            return Test.Text()
        }

        let diffHunks = changes.hunks(contextLines: contextLines)
        var segments: [Test.Text.Segment] = []

        for (hunkIndex, hunk) in diffHunks.enumerated() {
            if hunkIndex > 0 {
                segments.append(.init("\n", style: .plain))
            }

            segments.append(.init(hunk.header, style: .secondary))
            segments.append(.init("\n", style: .plain))

            for (lineIndex, line) in hunk.lines.enumerated() {
                let style: Test.Text.Segment.Style
                switch line {
                case .first: style = .diffRemoved
                case .second: style = .diffAdded
                case .both: style = .diffContext
                }

                segments.append(.init("\(line.marker)\(line.element)", style: style))

                if lineIndex < hunk.lines.count - 1 {
                    segments.append(.init("\n", style: .plain))
                }
            }
        }

        return Test.Text(segments)
    }
}
