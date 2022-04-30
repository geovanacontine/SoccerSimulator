import Foundation

public struct FouledAndRedCardAction: MatchActionProtocol {
    public let isFinalAction = true
    public let willAdvanceFieldSection = false
    public let willChangeBallPossession = false
    public let willResetFieldSection = false
    public let displayMessage: String? = "🟥"
}
