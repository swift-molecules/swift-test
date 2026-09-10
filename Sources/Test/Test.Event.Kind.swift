import Tagged

extension Test.Event {

    public typealias Kind = Tagged<Test.Event, Swift.String>
}

extension Tagged where Tag == Test.Event, Underlying == Swift.String {

    public static let runStarted: Self = "runStarted"

    public static let planCreated: Self = "planCreated"

    public static let runEnded: Self = "runEnded"

    public static let testStarted: Self = "testStarted"

    public static let caseStarted: Self = "caseStarted"

    public static let caseEnded: Self = "caseEnded"

    public static let testEnded: Self = "testEnded"

    public static let testSkipped: Self = "testSkipped"

    public static let expectationChecked: Self = "expectationChecked"

    public static let issueRecorded: Self = "issueRecorded"
}
