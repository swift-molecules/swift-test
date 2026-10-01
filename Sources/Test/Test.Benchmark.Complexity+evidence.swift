public import Numeric
public import Sample

extension Test.Benchmark.Complexity {

    public static func evidence(
        from points: [(size: Int, metric: Duration)],
        classes: [Class]
    ) -> Evidence {
        let averaging = Sample.Averaging<Duration>.duration

        var data = points.map { (size: $0.size, seconds: averaging.project($0.metric)) }
        data.sort { $0.size < $1.size }

        let valid = data.filter { $0.size > 0 && $0.seconds > 0 }

        guard valid.count >= 2 else {
            let emptyFit = Sample.Regression.Fit(
                slope: 0,
                intercept: 0,
                rSquared: 0,
                meanSquaredError: 0
            )
            return Evidence(
                exponent: Exponent(value: 0, coefficient: 0, fit: emptyFit),
                candidates: [],
                growthRatios: [],
                monotonicity: Test.Benchmark.Trend(z: 0, interpretation: .none),
                points: valid.map { (size: $0.size, metric: Duration.seconds($0.seconds)) },
                metricCV: .infinity
            )
        }

        let logX = valid.map { Double.math.log2(Double($0.size)) }
        let logY = valid.map { Double.math.log2($0.seconds) }
        let logLogFit = Sample.Regression.linear(x: logX, y: logY)
        let exponent = Exponent(
            value: logLogFit.slope,
            coefficient: Double.math.exp2(logLogFit.intercept),
            fit: logLogFit
        )

        let seconds = valid.map(\.seconds)
        var candidates: [Candidate.Fit] = []
        for cls in classes {
            let transformed = valid.map { cls.transform(Double($0.size)) }
            let fit = Sample.Regression.linear(x: transformed, y: seconds)

            var logSizesForExp: [Double] = []
            var logTransformsForExp: [Double] = []
            for i in valid.indices {
                let t = transformed[i]
                if t > 0 {
                    logSizesForExp.append(logX[i])
                    logTransformsForExp.append(Double.math.log2(t))
                }
            }
            let effectiveExp: Double
            if logTransformsForExp.count >= 2 {
                effectiveExp =
                    Sample.Regression.linear(
                        x: logSizesForExp,
                        y: logTransformsForExp
                    ).slope
            } else {
                effectiveExp = cls.theoreticalExponent ?? 0
            }

            candidates.append(
                Candidate.Fit(
                    complexity: cls,
                    regression: fit,
                    effectiveExponent: effectiveExp
                )
            )
        }
        candidates.sort { $0.regression.rSquared > $1.regression.rSquared }

        var growthRatios: [Double] = []
        for i in 1..<valid.count {
            guard valid[i - 1].seconds > 0 else { continue }
            growthRatios.append(valid[i].seconds / valid[i - 1].seconds)
        }

        let durations = valid.map { Duration.seconds($0.seconds) }
        let monotonicity = Test.Benchmark.Trend.mannKendall(durations)

        let metricCV: Double
        do {
            let mean = seconds.reduce(0, +) / Double(seconds.count)
            if mean > 0 {

                let variance =
                    seconds.reduce(0.0) { $0 + ($1 - mean) * ($1 - mean) }
                    / Double(seconds.count - 1)
                metricCV = variance.squareRoot() / mean
            } else {
                metricCV = .infinity
            }
        }

        return Evidence(
            exponent: exponent,
            candidates: candidates,
            growthRatios: growthRatios,
            monotonicity: monotonicity,
            points: valid.map { (size: $0.size, metric: Duration.seconds($0.seconds)) },
            metricCV: metricCV
        )
    }
}
