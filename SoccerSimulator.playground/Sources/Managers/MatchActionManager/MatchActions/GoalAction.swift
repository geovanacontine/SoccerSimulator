import Foundation

public struct GoalAction: MatchActionProtocol {
    public let isFinalAction = true
    public let willAdvanceFieldSection = false
    public let willChangeBallPossession = true
    public let willResetFieldSection = true
    public let displayMessage: String? = "⚽️"
}
