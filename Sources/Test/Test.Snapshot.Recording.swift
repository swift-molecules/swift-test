extension Test.Snapshot {

    public enum Recording: String, Sendable, Hashable, Codable, CaseIterable {

        case never

        case missing

        case failed

        case all
    }
}

extension Test.Snapshot.Recording: CustomStringConvertible {

    public var description: String { rawValue }
}
