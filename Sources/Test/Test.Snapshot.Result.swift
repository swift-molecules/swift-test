extension Test.Snapshot {

    public enum Result: Sendable {

        case matched

        case recorded(path: String)

        case failed(diff: Diff.Result, referencePath: String)

        case missingReference(path: String)

        case recordedInline(sourceFile: String)
    }
}

extension Test.Snapshot.Result {

    public var isPassing: Bool {
        switch self {
        case .matched:
            return true

        case .recorded:

            return true

        case .failed, .missingReference, .recordedInline:
            return false
        }
    }

    public var isFailing: Bool {
        !isPassing
    }
}

extension Test.Snapshot.Result: Hashable {}

extension Test.Snapshot.Result: CustomStringConvertible {

    public var description: String {
        switch self {
        case .matched:
            return "Snapshot matched"

        case .recorded(let path):
            return "Snapshot recorded at: \(path)"

        case .failed(let diff, let referencePath):
            return "Snapshot mismatch (reference: \(referencePath)): \(diff.summary)"

        case .missingReference(let path):
            return "Missing reference snapshot at: \(path)"

        case .recordedInline(let sourceFile):
            return "Inline snapshot recorded in: \(sourceFile). Re-run to assert."
        }
    }
}
