extension Test.Snapshot.Strategy where Format == String {

    public static func description<V>() -> Test.Snapshot.Strategy<V, String> {
        Test.Snapshot.Strategy<String, String>.lines.pullback { String(describing: $0) }
    }

    public static func customDescription<V: CustomStringConvertible>()
        -> Test.Snapshot.Strategy<V, String>
    {
        Test.Snapshot.Strategy<String, String>.lines.pullback { $0.description }
    }

    public static func debugDescription<V: CustomDebugStringConvertible>()
        -> Test.Snapshot.Strategy<V, String>
    {
        Test.Snapshot.Strategy<String, String>.lines.pullback { $0.debugDescription }
    }
}

extension Test.Snapshot.Strategy where Format == String {

    public static var dump: Self {
        Test.Snapshot.Strategy(
            pathExtension: "txt",
            diffing: .lines,
            snapshot: { value in
                var output = ""
                Swift.dump(value, to: &output)
                return output
            }
        )
    }
}
