import Foundation

public struct AdvanceFieldSectionAction: MatchActionProtocol {
    public let isFinalAction = false
    
    public func simulate(_ input: ActionInput) -> ActionOutput {
        let section = input.section.next ?? input.section
        
        let events: [Event] = [
            .init(time: 0, type: .advanceSection, team: input.team)
        ]
        
        return .init(section: section, team: input.team, events: events)
    }
}
