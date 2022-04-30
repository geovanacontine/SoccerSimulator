import Foundation

public class MatchEventManager {
    
    private var events: [Event]
    
    public init() {
        events = []
    }
    
    public func addEvent(_ event: Event) {
        events.append(event)
    }
    
    private func eventCount<T: MatchActionProtocol>(team: Team, action: T.Type) -> Int {
        events
            .filter({ $0.team == team })
            .compactMap({ $0.action as? T })
            .count
    }
}

// MARK: - Match facts

public extension MatchEventManager {
    func goals(_ team: Team) -> Int {
        eventCount(team: team, action: GoalAction.self)
    }
    
    func shotsOnTarget(_ team: Team) -> Int {
        eventCount(team: team, action: ShotOnTargetAction.self) +
        goals(team)
    }
    
    func attempts(_ team: Team) -> Int{
        eventCount(team: team, action: MissedShotAction.self) +
        shotsOnTarget(team)
    }
    
    func fouls(_ team: Team) -> Int{
        eventCount(team: team.reversed, action: FouledAction.self) +
        yellowCards(team) +
        redCards(team)
    }
    
    func yellowCards(_ team: Team) -> Int{
        eventCount(team: team.reversed, action: FouledAndYellowCardAction.self)
    }
    
    func redCards(_ team: Team) -> Int{
        eventCount(team: team.reversed, action: FouledAndRedCardAction.self)
    }
    
    func ballPossession(_ team: Team) -> Int {
        let totalEvents = events.count
        let teamEvents = events.filter({ $0.team == team }).count
        let rate = Double(teamEvents) / Double(totalEvents)
        let porcentage = rate * 100
        let rounded = porcentage.rounded(.toNearestOrAwayFromZero)
        return Int(rounded)
    }
}
