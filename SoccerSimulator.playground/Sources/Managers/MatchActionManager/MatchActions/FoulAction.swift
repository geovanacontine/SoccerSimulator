import Foundation

public struct FoulAction: MatchActionProtocol {
    public let isFinalAction = true
    
    // Base rates
    private let baseYellowCardRate: Int = 10
    private let baseRedCardRate: Int = 1
    
    public func simulate(_ input: ActionInput) -> ActionOutput {
        let events: [Event] = simulatedEvents(input)
        return .init(section: input.section, team: input.team, events: events)
    }
    
    private func simulatedEvents(_ input: ActionInput) -> [Event] {
        var events: [Event] = [.init(time: 0, type: .foul, team: input.team.reversed)]
        
        if let cardEventType = cardPossibilitiesArray(for: input.section)[Int.random(in: 0...99)] {
            events.append(.init(time: 0, type: cardEventType, team: input.team.reversed))
        }
        
        return events
    }
}

// MARK: - Cards

extension FoulAction {
    private func cardPossibilitiesArray(for section: FieldSection) -> [EventType?] {
        let cardRate = cardRateMultiplier(for: section)
        let yellowRate = baseYellowCardRate * cardRate
        let redRate = baseRedCardRate * cardRate
        let cardlessRate = 100 - yellowRate - redRate
        
        return .init(repeating: .yellowCard, count: yellowRate) +
        .init(repeating: .redCard, count: redRate) +
        .init(repeating: nil, count: cardlessRate)
    }
    
    private func cardRateMultiplier(for section: FieldSection) -> Int {
        switch section {
        case .attack, .goalkeeper:
            return 2
        default:
            return 1
        }
    }
}
