import Foundation

public struct PlayInput {
    let fieldSection: FieldSection
    let attackingTeam: Team
}

public class MatchActionManager {
    
    public func simulatePlay(_ input: PlayInput) -> MatchActionProtocol {
        var section = input.fieldSection
        var partialActionResult = simulatePartialPlay(section)
        
        while !partialActionResult.isFinalAction {
            section = section.next ?? .midfield
            partialActionResult = simulatePartialPlay(section)
        }
        
        return partialActionResult
    }
    
    private func simulatePartialPlay(_ section: FieldSection) -> MatchActionProtocol {
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
        .init(repeating: AdvanceFieldSectionAction(), count: 90) +
        .init(repeating: KeepBallPossessionAction(), count: 5) +
        .init(repeating: LoseBallPossessionAction(), count: 5)
    }
    
    private func midfieldPossibilitiesArray() -> [MatchActionProtocol] {
        .init(repeating: AdvanceFieldSectionAction(), count: 50) +
        .init(repeating: KeepBallPossessionAction(), count: 10) +
        .init(repeating: LoseBallPossessionAction(), count: 40)
    }
    
    private func attackPossibilitiesArray() -> [MatchActionProtocol] {
        .init(repeating: AdvanceFieldSectionAction(), count: 25) +
        .init(repeating: KeepBallPossessionAction(), count: 10) +
        .init(repeating: LoseBallPossessionAction(), count: 65)
    }
    
    private func goalkeeperPossibilitiesArray() -> [MatchActionProtocol] {
        .init(repeating: GoalAction(), count: 20) +
        .init(repeating: LoseBallPossessionAction(), count: 80)
    }
}
