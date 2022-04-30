import Foundation

public enum MatchSpeed {
    case slow
    case normal
    case fast
    case ultraFast
}

public extension MatchSpeed {
    var secondsBetweenInteractions: Double {
        switch self {
        case .slow:
            return 3
        case .normal:
            return 1
        case .fast:
            return 0.5
        case .ultraFast:
            return 0.01
        }
    }
}
