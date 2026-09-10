extension Test.Event {

    public enum Result: Sendable, Hashable, Codable {

        case passed

        case failed

        case skipped
    }
}
