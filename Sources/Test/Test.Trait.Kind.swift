extension Test.Trait {

    public enum Kind: Sendable, Hashable, Codable {

        case timeLimit(Duration)

        case tag(String)

        case enabled(Bool, Test.Text?)

        case bug(String, Test.Text?)

        case serialized

        case exclusive(String)

        case timed(Test.Benchmark.Configuration)
    }
}

extension Test.Trait.Kind: CustomStringConvertible {

    public var description: String {
        switch self {
        case .timeLimit(let duration):
            return ".timeLimit(\(duration))"

        case .tag(let name):
            return ".tag(\"\(name)\")"

        case .enabled(let isEnabled, let comment):
            if isEnabled {
                return ".enabled"
            } else if let comment {
                return ".disabled(\"\(comment.plainText)\")"
            } else {
                return ".disabled"
            }

        case .bug(let id, let comment):
            guard let comment else { return ".bug(\"\(id)\")" }
            return ".bug(\"\(id)\", \"\(comment.plainText)\")"

        case .serialized:
            return ".serialized"

        case .exclusive(let group):
            return ".exclusive(\"\(group)\")"

        case .timed(let config):
            return ".timed(iterations: \(config.iteration.count))"
        }
    }
}
