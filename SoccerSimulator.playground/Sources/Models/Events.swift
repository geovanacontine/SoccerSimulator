import Foundation

public struct Event {
    let time: Int
    let action: MatchActionProtocol
    let team: Team
}
