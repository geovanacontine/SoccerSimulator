import Foundation

public struct MissedShotAction: MatchActionProtocol {
    public let isFinalAction = true
    public let willAdvanceFieldSection = false
    public let willChangeBallPossession = true
    public let willResetFieldSection = false
    public let displayMessage: String? = nil
}
