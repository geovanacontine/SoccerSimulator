import Foundation

public struct KeepBallPossessionAction: MatchActionProtocol {
    public let isFinalAction = true
    public let willAdvanceFieldSection = false
    public let willChangeBallPossession = false
    public let willResetFieldSection = false
    public let isMatchEvent = false
    public let displayMessage: String? = nil
}
