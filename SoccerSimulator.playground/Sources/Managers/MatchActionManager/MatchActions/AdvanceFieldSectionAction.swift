import Foundation

public struct AdvanceFieldSectionAction: MatchActionProtocol {
    public let isFinalAction = false
    public let willAdvanceFieldSection = true
    public let willChangeBallPossession = false
    public let willResetFieldSection = false
    public let displayMessage: String? = nil
}
