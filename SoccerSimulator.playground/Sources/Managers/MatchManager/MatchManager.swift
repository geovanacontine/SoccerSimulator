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
        let input = ActionInput(section: activeSection, team: activeTeam)
        let output = actionManager.simulatePlay(input)
        
        eventManager.addEvents(
            output.events.map { event in
                .init(time: time, type: event.type, team: event.team)
            }
        )
        
        updateDisplay(output.events.last)
        
        activeSection = output.section
        activeTeam = output.team
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
    private func updateDisplay(_ event: Event?) {
        let homeGoals = eventManager.matchFacts(team: .home).goals
        let awayGoals = eventManager.matchFacts(team: .away).goals
        let formattedTime = String(format: "%02d", time)
        let customMessage = event?.type.displayText ?? ""
        
        print("\(homeGoals) x \(awayGoals) | \(formattedTime)' - \(gameHalf)° | \(customMessage)")
    }
    
    private func showStatistics() {
        let homeFacts = eventManager.matchFacts(team: .home)
        let awayFacts = eventManager.matchFacts(team: .away)
        
        print("")
        print("------- Match facts -------")
        print("")
        print("\(homeFacts.goals.formatted())      Goals      \(awayFacts.goals.formatted())")
        print("\(homeFacts.attempts.formatted())     Attempts    \(awayFacts.attempts.formatted())")
        print("\(homeFacts.onTarget.formatted())     On target   \(awayFacts.onTarget.formatted())")
        print("\(homeFacts.fouls.formatted())      Fouls      \(awayFacts.fouls.formatted())")
        print("\(homeFacts.yellowCards.formatted())   Yellow cards  \(awayFacts.yellowCards.formatted())")
        print("\(homeFacts.redCards.formatted())    Red cards    \(awayFacts.redCards.formatted())")
        print("\(homeFacts.possession.formatted())%   Possession   \(awayFacts.possession.formatted())%")
        print("")
        print("---------------------------")
    }
}

extension Int {
    func formatted() -> String {
        String(format: "%02d", self)
    }
}
