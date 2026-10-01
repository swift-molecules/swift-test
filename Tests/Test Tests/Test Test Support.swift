import Source
public import Source
public import Test

extension Source.Location {

    public static func stub(
        fileID: String = "TestModule/File.swift",
        filePath: String? = nil,
        line: Int = 1,
        column: Int = 1
    ) -> Self {
        .init(fileID: fileID, filePath: filePath, line: line, column: column)
    }
}

extension Test.ID {

    public static func stub(
        _ name: String,
        module: String = "TestModule",
        suite: String? = nil,
        line: Int = 1
    ) -> Self {
        .init(
            module: module,
            suite: suite,
            name: name,
            sourceLocation: .stub(line: line)
        )
    }
}

extension Test.Text {

    public static func stub(_ string: String) -> Self {
        Self(string)
    }
}

extension Test.Trait {

    public static func stubTag(_ name: String) -> Self {
        .tag(name)
    }

    public static func stubTimeLimit(_ duration: Duration) -> Self {
        .timeLimit(duration)
    }
}
