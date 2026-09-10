extension Bool?: @retroactive CaseIterable {

    public static let allCases: [Bool?] = [.some(true), .some(false), .none]
}

extension [(Bool?, Bool?)] {

    public static let allCases: Self = Bool?.allCases.flatMap { first in
        Bool?.allCases.map { second in (first, second) }
    }
}

extension [(Bool?, Bool?, Bool?)] {

    public static let allCases: Self = [(Bool?, Bool?)].allCases.flatMap { first, second in
        Bool?.allCases.map { third in (first, second, third) }
    }
}

extension [(Bool?, Bool?, Bool?, Bool?)] {

    public static let allCases: Self = [(Bool?, Bool?, Bool?)].allCases.flatMap {
        first,
        second,
        third in
        Bool?.allCases.map { fourth in (first, second, third, fourth) }
    }
}

extension [(Bool?, Bool?, Bool?, Bool?, Bool?)] {

    public static let allCases: Self = [(Bool?, Bool?, Bool?, Bool?)].allCases.flatMap {
        first,
        second,
        third,
        fourth in
        Bool?.allCases.map { fifth in (first, second, third, fourth, fifth) }
    }
}

extension [(Bool?, Bool?, Bool?, Bool?, Bool?, Bool?)] {

    public static let allCases: Self = [(Bool?, Bool?, Bool?, Bool?, Bool?)].allCases.flatMap {
        first,
        second,
        third,
        fourth,
        fifth in
        Bool?.allCases.map { sixth in (first, second, third, fourth, fifth, sixth) }
    }

}
