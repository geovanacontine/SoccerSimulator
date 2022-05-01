import Foundation

public struct KeepBallPossessionAction: MatchActionProtocol {
    public let isFinalAction = true
    
    public func simulate(_ input: ActionInput) -> ActionOutput {
        let events: [Event] = [
            .init(time: 0, type: .keepBall, team: input.team)
        ]
        
        return .init(section: input.section, team: input.team, events: events)
    }
}
