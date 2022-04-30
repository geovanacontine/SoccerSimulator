import Foundation

public class MatchManager {
    
    // Dependencies
    private let actionManager = MatchActionManager()
    private let eventManager = MatchEventManager()
    
    // Configurations
    private let speed: MatchSpeed
    private let pace: Int = 1
    
    // Internal flow
    private var willEndGame = false
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
            self.time += self.pace
            self.executePlay()
            self.didUpdateTime()
            
            if self.willEndGame {
                timer.invalidate()
                self.didEndGame()
            }
        }
    }
}

// MARK: - Play Simulation

extension MatchManager {
    private func executePlay() {
        let input = PlayInput(fieldSection: activeSection, attackingTeam: activeTeam)
        let output = actionManager.simulatePlay(input)
        
        eventManager.addEvent(.init(time: time, action: output.action, team: activeTeam))
        updateDisplay(output.action)
        
        activeSection = output.fieldSection
        activeTeam = output.attackingTeam
    }
}

// MARK: - Time Simulation

extension MatchManager {
    private func didUpdateTime() {
        if time == maxRegularGameTime {
            additionalTime = simulateAdditionalTime()
        }
        
        if time >= (maxRegularGameTime + additionalTime) {
            gameHalf += 1
            time = 0
            additionalTime = 0
        }
        
        if gameHalf > maxGameHalfs {
            willEndGame = true
        }
    }
    
    private func simulateAdditionalTime() -> Int {
        let maxTime = gameHalf == 1 ? maxFirstHalfAdditionalTime : maxLastHalfAdditionalTime
        return Int.random(in: 0...maxTime)
    }
    
    private func didEndGame() {
        showStatistics()
    }
}

// MARK: - Display

extension MatchManager {
    private func updateDisplay(_ action: MatchActionProtocol) {
        let homeGoals = eventManager.goals(.home)
        let awayGoals = eventManager.goals(.away)
        let formattedTime = String(format: "%02d", time)
        let customMessage = action.displayMessage ?? ""
        
        print("\(homeGoals) x \(awayGoals) | \(formattedTime)' - \(gameHalf)° | \(customMessage)")
    }
    
    private func showStatistics() {
        print("")
        print("------- Match facts -------")
        print("")
        print("\(eventManager.goals(.home).formatted())      Goals      \(eventManager.goals(.away).formatted())")
        print("\(eventManager.attempts(.home).formatted())     Attempts    \(eventManager.attempts(.away).formatted())")
        print("\(eventManager.shotsOnTarget(.home).formatted())     On target   \(eventManager.shotsOnTarget(.away).formatted())")
        print("\(eventManager.fouls(.home).formatted())      Fouls      \(eventManager.fouls(.away).formatted())")
        print("\(eventManager.yellowCards(.home).formatted())   Yellow cards  \(eventManager.yellowCards(.away).formatted())")
        print("\(eventManager.redCards(.home).formatted())    Red cards    \(eventManager.redCards(.away).formatted())")
        print("\(eventManager.ballPossession(.home).formatted())%   Possession   \(eventManager.ballPossession(.away).formatted())%")
        print("")
        print("---------------------------")
    }
}

extension Int {
    func formatted() -> String {
        String(format: "%02d", self)
    }
}
