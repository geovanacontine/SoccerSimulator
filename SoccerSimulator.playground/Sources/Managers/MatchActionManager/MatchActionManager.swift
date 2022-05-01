import Foundation

public class MatchActionManager {
    
    public func simulatePlay(_ input: ActionInput) -> ActionOutput {
        var section = input.section
        var action = randomAction(section)
        var pastEvents: [Event] = []

        while !action.isFinalAction {
            let output = action.simulate(.init(section: section, team: input.team))
            pastEvents += output.events
            section = output.section
            action = randomAction(section)
        }
        
        let output = action.simulate(.init(section: section, team: input.team))
        let totalEvents = pastEvents + output.events
        return .init(section: output.section, team: output.team, events: totalEvents)
    }
    
    private func randomAction(_ section: FieldSection) -> MatchActionProtocol {
        let possibilities = getPossibilitiesArray(fieldSection: section)
        let randomNumber = Int.random(in: 0...99)
        return possibilities[randomNumber]
    }
    
    private func getPossibilitiesArray(fieldSection: FieldSection) -> [MatchActionProtocol] {
        switch fieldSection {
        case .defense:
            return defensePossibilitiesArray()
        case .midfield:
            return midfieldPossibilitiesArray()
        case .attack:
            return attackPossibilitiesArray()
        case .goalkeeper:
            return goalkeeperPossibilitiesArray()
        }
    }
    
    private func defensePossibilitiesArray() -> [MatchActionProtocol] {
        .init(repeating: AdvanceFieldSectionAction(), count: 85) +
        .init(repeating: KeepBallPossessionAction(), count: 5) +
        .init(repeating: LoseBallPossessionAction(), count: 5) +
        .init(repeating: FoulAction(), count: 5)
    }
    
    private func midfieldPossibilitiesArray() -> [MatchActionProtocol] {
        .init(repeating: AdvanceFieldSectionAction(), count: 40) +
        .init(repeating: KeepBallPossessionAction(), count: 10) +
        .init(repeating: LoseBallPossessionAction(), count: 39) +
        .init(repeating: FinishAction(), count: 1) +
        .init(repeating: FoulAction(), count: 10)
    }
    
    private func attackPossibilitiesArray() -> [MatchActionProtocol] {
        .init(repeating: AdvanceFieldSectionAction(), count: 25) +
        .init(repeating: KeepBallPossessionAction(), count: 10) +
        .init(repeating: LoseBallPossessionAction(), count: 50) +
        .init(repeating: FinishAction(), count: 5) +
        .init(repeating: FoulAction(), count: 10)
    }
    
    private func goalkeeperPossibilitiesArray() -> [MatchActionProtocol] {
        .init(repeating: FinishAction(), count: 95) +
        .init(repeating: FoulAction(), count: 5)
    }
}
