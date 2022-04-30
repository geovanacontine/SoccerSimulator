import Foundation

public enum FieldSection: CaseIterable, Equatable {
    case defense
    case midfield
    case attack
    case goalkeeper
    
    var reversed: FieldSection {
        switch self {
        case .defense:
            return .attack
        case .midfield:
            return .midfield
        case .attack, .goalkeeper:
            return .defense
        }
    }
}
