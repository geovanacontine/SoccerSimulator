import Foundation

public struct FinishAction: MatchActionProtocol {
    public let isFinalAction = true
    
    public func simulate(_ input: ActionInput) -> ActionOutput {
        let events: [Event] = simulatedEvents(input)
        let hasGoalEvent = events.contains(where: { $0.type == .goal })
        let section: FieldSection = hasGoalEvent ? .midfield : input.section.reversed
        
        return .init(section: section, team: input.team.reversed, events: events)
    }
    
    private func simulatedEvents(_ input: ActionInput) -> [Event] {
        let resultEventType = possibilitiesArray()[Int.random(in: 0...99)]
        let resultEvent: Event = .init(time: 0, type: resultEventType, team: input.team)
        let baseEvent: Event = .init(time: 0, type: .shotAttempt, team: input.team)
        let subEvents = subEvents(for: resultEventType, team: input.team)
        
        return [baseEvent] + subEvents + [resultEvent]
    }
    
    private func possibilitiesArray() -> [EventType] {
        .init(repeating: .goal, count: 20) +
        .init(repeating: .shotOnTarget, count: 30) +
        .init(repeating: .missedShot, count: 50)
    }
    
    private func subEvents(for eventType: EventType, team: Team) -> [Event] {
        switch eventType {
        case .goal:
            return [.init(time: 0, type: .shotOnTarget, team: team)]
        case .shotOnTarget:
            return [.init(time: 0, type: .save, team: team.reversed)]
        default:
            return []
        }
    }
}
