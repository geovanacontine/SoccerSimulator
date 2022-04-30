import Foundation

public extension CaseIterable where Self: Equatable {
    var allCases: AllCases { Self.allCases }

    var next: Self? {
        guard let currentIndex = allCases.firstIndex(of: self) else { return nil }

        let index = allCases.index(after: currentIndex)

        guard index != allCases.endIndex else { return nil }
        return allCases[index]
    }

    var previous: Self? {
        guard let currentIndex = allCases.firstIndex(of: self) else { return nil }

        guard currentIndex != allCases.startIndex else { return nil }
        let index = allCases.index(currentIndex, offsetBy: -1)

        return allCases[index]
    }
}
