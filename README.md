# Test

[![CI](https://github.com/swift-primitives/swift-test/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-primitives/swift-test/actions/workflows/ci.yml)

Runner-neutral test identity, outcomes, issues, attachments, explicit recording context, and statically composed scoped modifiers.

```swift
import Test

let recorder = Test.Recorder(issue: { issue in
    print(issue)
})
let context = Test.Context(recorder: recorder)
```

This package does not define test declaration macros, discovery, registration, cases, plans, expectations, requirements, or a runner. Apple’s toolchain `Testing` module remains the framework authority.

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
