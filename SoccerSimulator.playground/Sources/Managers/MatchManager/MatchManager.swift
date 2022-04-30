import Foundation

public class MatchManager {
    
    // Dependencies
    private let actionManager = MatchActionManager()
    private let eventManager = MatchEventManager()
    
    // Configurations
    private let speed: MatchSpeed
    private let pace: Int = 1
    
    // Internal flow
    private var didEndGame = false
    private var time: Int = 0
    private var additionalTime: Int = 0
    private var gameHalf: Int = 1
    private var activeTeam: Team = Team.allCases.randomElement() ?? .home
    private var activeSection: FieldSection = .midfield
    
    // Constants
    private let maxGameHalfs: Int = 2
    private let maxRegularGameTime: Int = 45
    private let maxFirstHalfAdditionalTime: Int = 3
    private let maxLastHalfAdditionalTime: Int = 7
    
    public init(speed: MatchSpeed) {
        self.speed = speed
    }
}

// MARK: - Main Loop

extension MatchManager {
    public func startMatch() {
        Timer.scheduledTimer(withTimeInterval: speed.secondsBetweenInteractions, repeats: true) { timer in
            self.executePlay()
            self.didUpdateTime()
            
            if self.didEndGame {
                timer.invalidate()
            }
        }
    }
}

// MARK: - Play Simulation

extension MatchManager {
    private func executePlay() {
        let input = PlayInput(fieldSection: activeSection, attackingTeam: activeTeam)
        let output = actionManager.simulatePlay(input)
        
        if output.willAdvanceFieldSection {
            activeSection = activeSection.next ?? .midfield
        } else if output.willResetFieldSection {
            activeSection = .midfield
        }
        
        if output.willChangeBallPossession {
            activeTeam = activeTeam.reversed
            activeSection = activeSection.reversed
        }
        
        if output.isMatchEvent {
            eventManager.addEvent(.init(time: time, action: output, team: activeTeam))
        }
        
        updateDisplay(output)
    }
}

// MARK: - Time Simulation

extension MatchManager {
    private func didUpdateTime() {
        time += pace
        
        if time == maxRegularGameTime {
            additionalTime = simulateAdditionalTime()
        }
        
        if time >= (maxRegularGameTime + additionalTime) {
            gameHalf += 1
            time = 0
            additionalTime = 0
            print("")
        }
        
        if gameHalf > maxGameHalfs {
            didEndGame = true
        }
    }
    
    private func simulateAdditionalTime() -> Int {
        let maxTime = gameHalf == 1 ? maxFirstHalfAdditionalTime : maxLastHalfAdditionalTime
        return Int.random(in: 0...maxTime)
    }
}

// MARK: - Display

extension MatchManager {
    private func updateDisplay(_ action: MatchActionProtocol) {
        let homeGoals = eventManager.goals(forTeam: .home)
        let awayGoals = eventManager.goals(forTeam: .away)
        let formattedTime = String(format: "%02d", time)
        let customMessage = action.displayMessage ?? ""
        
        print("\(homeGoals) x \(awayGoals) | \(formattedTime)' - \(gameHalf)° | \(customMessage)")
    }
}
