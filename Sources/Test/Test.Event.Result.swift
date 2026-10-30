extension Test.Event {

    public enum Result: Sendable, Hashable {

        case passed

        case failed

        case skipped
    }
}

#if !hasFeature(Embedded)
    extension Test.Event.Result: Codable {}
#endif
