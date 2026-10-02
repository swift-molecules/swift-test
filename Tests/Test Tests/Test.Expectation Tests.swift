import Tagged
import Foundation
import Test
import Testing

private typealias SUT = Test::Test

@Suite
struct `Test.Expectation` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
}

extension `Test.Expectation`.Unit {
    @Test
    func `passing expectation`() {
        let expr = SUT.Expression(
            id: 1,
            sourceCode: "x == 42",
            sourceLocation: .stub()
        )
        let expectation = SUT.Expectation(
            id: 1,
            expression: expr,
            isPassing: true
        )
        #expect(expectation.isPassing)
        #expect(!expectation.isFailing)
        #expect(expectation.failure == nil)
    }

    @Test
    func `failing expectation with failure`() {
        let expr = SUT.Expression(
            id: 1,
            sourceCode: "x == 42",
            sourceLocation: .stub()
        )
        let failure = SUT.Expectation.Failure(
            message: "Expected 42, got 0"
        )
        let expectation = SUT.Expectation(
            id: 2,
            expression: expr,
            isPassing: false,
            failure: failure
        )
        #expect(!expectation.isPassing)
        #expect(expectation.isFailing)
        #expect(expectation.failure != nil)
    }

    @Test
    func `Failure stores all fields`() {
        let failure = SUT.Expectation.Failure(
            message: "mismatch",
            expected: .init(stringValue: "42", typeDescription: "Int"),
            actual: .init(stringValue: "0", typeDescription: "Int"),
            difference: "expected 42, got 0",
            comment: "check initial value"
        )
        #expect(failure.message.plainText == "mismatch")
        #expect(failure.expected?.stringValue == "42")
        #expect(failure.actual?.stringValue == "0")
        #expect(failure.difference != nil)
        #expect(failure.comment != nil)
    }

    @Test
    func `Failure defaults optionals to nil`() {
        let failure = SUT.Expectation.Failure(message: "failed")
        #expect(failure.expected == nil)
        #expect(failure.actual == nil)
        #expect(failure.difference == nil)
        #expect(failure.comment == nil)
    }
}

extension `Test.Expectation`.`Edge Case` {
    @Test
    func `codable round-trip for passing`() throws {
        let original = SUT.Expectation(
            id: 1,
            expression: .init(id: 1, sourceCode: "true", sourceLocation: .stub()),
            isPassing: true
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(SUT.Expectation.self, from: data)
        #expect(decoded == original)
    }

    @Test
    func `codable round-trip for failing with failure`() throws {
        let failure = SUT.Expectation.Failure(
            message: "mismatch",
            expected: .init(stringValue: "42", typeDescription: "Int")
        )
        let original = SUT.Expectation(
            id: 2,
            expression: .init(id: 1, sourceCode: "x == 42", sourceLocation: .stub()),
            isPassing: false,
            failure: failure
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(SUT.Expectation.self, from: data)
        #expect(decoded == original)
    }
}

extension `Test.Expectation`.`Edge Case` {
    static func encoded(isPassing: Bool) throws -> [String: Any] {
        let expectation = SUT.Expectation(
            id: 7,
            expression: SUT.Expression(id: 1, sourceCode: "x == 42", sourceLocation: .stub()),
            isPassing: isPassing,
            failure: isPassing ? nil : SUT.Expectation.Failure(message: "Expected 42, got 0")
        )
        return try #require(
            try JSONSerialization.jsonObject(with: try JSONEncoder().encode(expectation)) as? [String: Any]
        )
    }

    @Test(arguments: [true, false])
    func `a consistent expectation survives a JSON round trip`(_ isPassing: Bool) throws {
        let data = try JSONSerialization.data(withJSONObject: try Self.encoded(isPassing: isPassing))
        let decoded = try JSONDecoder().decode(SUT.Expectation.self, from: data)
        #expect(decoded.isPassing == isPassing)
        #expect((decoded.failure == nil) == isPassing)
    }

    @Test
    func `decoding a passing expectation that carries a failure throws`() throws {
        var object = try Self.encoded(isPassing: false)
        object["isPassing"] = true
        let data = try JSONSerialization.data(withJSONObject: object)
        #expect(throws: DecodingError.self) { try JSONDecoder().decode(SUT.Expectation.self, from: data) }
    }

    @Test
    func `decoding a failing expectation without a failure throws`() throws {
        var object = try Self.encoded(isPassing: true)
        object["isPassing"] = false
        let data = try JSONSerialization.data(withJSONObject: object)
        #expect(throws: DecodingError.self) { try JSONDecoder().decode(SUT.Expectation.self, from: data) }
    }
}
