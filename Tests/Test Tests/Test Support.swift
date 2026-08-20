// This source file is part of the swift-test open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-test project authors
// Licensed under Apache License v2.0

import Source_Primitives
import Synchronization
import Test

typealias NeutralTest = Test

final class Trace: @unchecked Sendable {
    let values = Mutex<[String]>([])
}

func source() -> Source.Location {
    .init(fileID: "ExampleTests/Feature.swift", line: 12, column: 3)
}

func identity(source: Source.Location) -> NeutralTest.ID {
    .init(module: "ExampleTests", suite: "Feature", name: "works", source: source)
}
