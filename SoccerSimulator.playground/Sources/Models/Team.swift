import Foundation

public enum Team: String, CaseIterable {
    case home
    case away
    
    var reversed: Team {
        switch self {
        case .home:
            return .away
        case .away:
            return .home
        }
    }
}
