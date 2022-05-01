import Foundation

public struct LoseBallPossessionAction: MatchActionProtocol {
    public let isFinalAction = true
    
    public func simulate(_ input: ActionInput) -> ActionOutput {
        let events: [Event] = [
            .init(time: 0, type: .loseBall, team: input.team),
            .init(time: 0, type: .successfulTackle, team: input.team.reversed)
        ]
        
        return .init(section: input.section.reversed, team: input.team.reversed, events: events)
    }
}
