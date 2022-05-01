import Foundation

public class MatchEventManager {
    
    private var events: [Event]
    
    public init() {
        events = []
    }
    
    public func addEvents(_ newEvents: [Event]) {
        events += newEvents
    }
}

// MARK: - Match facts

public extension MatchEventManager {
    func matchFacts(team: Team) -> MatchFacts {
        .init(goals: count(type: .goal, team: team),
              attempts: count(type: .shotAttempt, team: team),
              onTarget: count(type: .shotOnTarget, team: team),
              fouls: count(type: .foul, team: team),
              yellowCards: count(type: .yellowCard, team: team),
              redCards: count(type: .redCard, team: team),
              possession: ballPossession(team))
    }
    
    private func count(type: EventType, team: Team) -> Int {
        events
            .filter({ $0.team == team && $0.type == type })
            .count
    }
    
    private func ballPossession(_ team: Team) -> Int {
        let totalEvents = events.count
        let teamEvents = events.filter({ $0.team == team }).count
        let rate = Double(teamEvents) / Double(totalEvents)
        let porcentage = rate * 100
        let rounded = porcentage.rounded(.toNearestOrAwayFromZero)
        return Int(rounded)
    }
}
