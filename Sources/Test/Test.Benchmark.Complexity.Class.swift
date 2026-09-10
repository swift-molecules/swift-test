import Numeric

extension Test.Benchmark.Complexity {

    public enum Class: Swift.String, Sendable, Hashable, Codable, CaseIterable, Comparable {

        case constant

        case logarithmic

        case squareRoot

        case linear

        case linearithmic

        case quadratic

        case cubic

        case exponential
    }
}

extension Test.Benchmark.Complexity.Class {

    public func transform(_ n: Double) -> Double {
        switch self {
        case .constant: 1.0
        case .logarithmic: Double.math.log2(n)
        case .squareRoot: n.squareRoot()
        case .linear: n
        case .linearithmic: n * Double.math.log2(n)
        case .quadratic: n * n
        case .cubic: n * n * n
        case .exponential: Double.math.exp2(n)
        }
    }

    public var theoreticalExponent: Double? {
        switch self {
        case .constant: 0.0
        case .logarithmic: nil
        case .squareRoot: 0.5
        case .linear: 1.0
        case .linearithmic: nil
        case .quadratic: 2.0
        case .cubic: 3.0
        case .exponential: nil
        }
    }

    var order: Int {
        switch self {
        case .constant: 0
        case .logarithmic: 1
        case .squareRoot: 2
        case .linear: 3
        case .linearithmic: 4
        case .quadratic: 5
        case .cubic: 6
        case .exponential: 7
        }
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.order < rhs.order
    }
}
