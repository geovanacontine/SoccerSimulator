import Foundation

public protocol MatchActionProtocol {
    var isFinalAction: Bool { get }
    func simulate(_ input: ActionInput) -> ActionOutput
}
