import Foundation

public struct ShotOnTargetAction: MatchActionProtocol {
    public let isFinalAction = true
    public let willAdvanceFieldSection = false
    public let willChangeBallPossession = true
    public let willResetFieldSection = false
    public let displayMessage: String? = nil
}
