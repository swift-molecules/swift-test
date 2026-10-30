extension Test.Snapshot {

    public enum Recording: String, Sendable, Hashable, CaseIterable {

        case never

        case missing

        case failed

        case all
    }
}

extension Test.Snapshot.Recording: CustomStringConvertible {

    public var description: String { rawValue }
}

#if !hasFeature(Embedded)
    extension Test.Snapshot.Recording: Codable {}
#endif
