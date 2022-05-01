import Foundation

public enum EventType {
    case goal
    case shotAttempt
    case shotOnTarget
    case missedShot
    case save
    case foul
    case yellowCard
    case redCard
    case loseBall
    case successfulTackle
    case advanceSection
    case keepBall
}

extension EventType {
    var displayText: String {
        switch self {
        case .goal: return "⚽️"
        case .yellowCard: return "🟨"
        case .redCard: return "🟥"
        default:
            return ""
        }
    }
}

public struct Event {
    let time: Int
    let type: EventType
    let team: Team
}
