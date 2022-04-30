import Foundation

public struct PlayInput {
    let fieldSection: FieldSection
    let attackingTeam: Team
}

public struct PlayOutput {
    var fieldSection: FieldSection
    var attackingTeam: Team
    let action: MatchActionProtocol
    
    public init(fieldSection: FieldSection, attackingTeam: Team, action: MatchActionProtocol) {
        self.fieldSection = fieldSection
        self.attackingTeam = attackingTeam
        self.action = action
        
        updatedFieldSection()
        updateAttackingTeam()
    }
    
    private mutating func updateAttackingTeam() {
        if action.willChangeBallPossession {
            attackingTeam = attackingTeam.reversed
            fieldSection = fieldSection.reversed
        }
    }
    
    private mutating func updatedFieldSection() {
        if action.willAdvanceFieldSection {
            fieldSection = fieldSection.next ?? .midfield
        } else if action.willResetFieldSection {
            fieldSection = .midfield
        }
    }
}

public class MatchActionManager {
    
    public func simulatePlay(_ input: PlayInput) -> PlayOutput {
        var section = input.fieldSection
        var partialActionResult = simulatePartialPlay(section)
        
        let action = String(describing: type(of: partialActionResult))
//        print("")
//        print("\(input.attackingTeam) - \(section) - \(action)")
        
        while !partialActionResult.isFinalAction {
            section = section.next ?? .midfield
            partialActionResult = simulatePartialPlay(section)
            
            let action = String(describing: type(of: partialActionResult))
//            print("\(input.attackingTeam) - \(section) - \(action)")
        }
        
        return .init(fieldSection: section, attackingTeam: input.attackingTeam, action: partialActionResult)
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
        baseArray(advance: 85, keep: 5, lose: 5) +
        .init(repeating: FouledAction(), count: 4) +
        .init(repeating: FouledAndYellowCardAction(), count: 1)
    }
    
    private func midfieldPossibilitiesArray() -> [MatchActionProtocol] {
        baseArray(advance: 45, keep: 10, lose: 35) +
        .init(repeating: FouledAction(), count: 8) +
        .init(repeating: FouledAndYellowCardAction(), count: 2)
    }
    
    private func attackPossibilitiesArray() -> [MatchActionProtocol] {
        baseArray(advance: 25, keep: 10, lose: 55) +
        .init(repeating: FouledAction(), count: 6) +
        .init(repeating: FouledAndYellowCardAction(), count: 3) +
        .init(repeating: FouledAndRedCardAction(), count: 1)
    }
    
    private func goalkeeperPossibilitiesArray() -> [MatchActionProtocol] {
        .init(repeating: GoalAction(), count: 20) +
        .init(repeating: ShotOnTargetAction(), count: 30) +
        .init(repeating: MissedShotAction(), count: 48) +
        .init(repeating: FouledAndYellowCardAction(), count: 1) +
        .init(repeating: FouledAndRedCardAction(), count: 1)
    }
    
    private func baseArray(advance: Int, keep: Int, lose: Int) -> [MatchActionProtocol] {
        .init(repeating: AdvanceFieldSectionAction(), count: advance) +
        .init(repeating: KeepBallPossessionAction(), count: keep) +
        .init(repeating: LoseBallPossessionAction(), count: lose)
    }
}
