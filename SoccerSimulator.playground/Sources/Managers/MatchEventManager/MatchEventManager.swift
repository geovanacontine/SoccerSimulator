import Foundation

public class MatchEventManager {
    
    private var events: [Event]
    
    public init() {
        events = []
    }
    
    public func addEvent(_ event: Event) {
        events.append(event)
    }
    
    public func goals(forTeam team: Team) -> Int {
        events
            .filter({ $0.action is GoalAction })
            .filter({ $0.team == team })
            .count
    }
}
