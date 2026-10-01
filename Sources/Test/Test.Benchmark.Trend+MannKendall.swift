public import Sample

extension Test.Benchmark.Trend {

    public static func mannKendall(_ durations: [Duration]) -> Self {
        let n = durations.count
        guard n >= 3 else {
            return Self(z: 0, interpretation: .none)
        }

        let averaging = Sample.Averaging<Duration>.duration

        var s: Int = 0
        for i in 0..<(n - 1) {
            let xi = averaging.project(durations[i])
            for j in (i + 1)..<n {
                let xj = averaging.project(durations[j])
                let diff = xj - xi
                if diff > 0 { s += 1 } else if diff < 0 { s -= 1 }
            }
        }

        let variance = Double(n * (n - 1) * (2 * n + 5)) / 18.0

        let z: Double
        if s > 0 {
            z = (Double(s) - 1.0) / variance.squareRoot()
        } else if s < 0 {
            z = (Double(s) + 1.0) / variance.squareRoot()
        } else {
            z = 0.0
        }

        let interpretation: Interpretation
        if z > 1.96 {
            interpretation = .increasing
        } else if z < -1.96 {
            interpretation = .decreasing
        } else {
            interpretation = .none
        }

        return Self(z: z, interpretation: interpretation)
    }
}
