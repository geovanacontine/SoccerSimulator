import Foundation

public protocol MatchActionProtocol {
    // Action Simulation
    var isFinalAction: Bool { get }
    
    // Match Simulation
    var willAdvanceFieldSection: Bool { get }
    var willChangeBallPossession: Bool { get }
    var willResetFieldSection: Bool { get }
    
    // Event
    var isMatchEvent: Bool { get }
    
    // Display
    var displayMessage: String? { get }
}
