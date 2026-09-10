extension Test.Snapshot.Diff.Result {

    public enum Operation: Sendable, Hashable, Codable {

        case added(path: Swift.String, value: Swift.String)

        case removed(path: Swift.String, value: Swift.String)

        case modified(path: Swift.String, old: Swift.String, new: Swift.String)
    }
}
