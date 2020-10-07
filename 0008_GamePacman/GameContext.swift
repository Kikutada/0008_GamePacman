//
//  GameContext.swift
//  0003_GameArchTest
//
//  Created by Kikutada on 2020/08/12.
//  Copyright © 2020 Kikutada. All rights reserved.
//

import Foundation

/// Context and settings for game
class CgContext {

    enum EnLevel: Int {
        case Level_A = 0, Level_B, Level_C, Level_D
    }

    enum EnOperationMode: Int {
        case Swipe = 0, Touch, Accel
        
        func getString() -> String {
            switch self {
                case .Swipe: return "(SWIPE)"
                case .Touch: return "(TOUCH)"
                case .Accel: return "(ACCEL)"
            }
        }
        
        func getNext() -> EnOperationMode {
            switch self {
                case .Swipe: return .Touch
                case .Touch: return .Accel
                case .Accel: return .Swipe
            }
        }
    }

    enum EnLanguage: Int {
        case English = 0, Japanese
        
        func getString() -> String {
            switch self {
                case .English:  return "(ENGLISH) "
                case .Japanese: return "(JAPANESE)"
            }
        }
        
        func getNext() -> EnLanguage {
            switch self {
            case .English: return .Japanese
            case .Japanese: return .English
            }
        }
    }

    enum EnOnOff: Int {
        case Off = 0, On
        
        func getString() -> String {
            switch self {
                case .On:  return "(ON) "
                case .Off: return "(OFF)"
            }
        }
        
        func getNext() -> EnOnOff {
            switch self {
            case .On: return .Off
            case .Off: return .On
            }
        }
    }

    enum EnSetting: Int {
        case Clear = 0, Keep
        
        func getString() -> String {
            switch self {
                case .Clear: return "(CLEAR)"
                case .Keep:  return "(KEEP) "
            }
        }
        
        func getNext() -> EnSetting {
            switch self {
            case .Clear: return .Keep
            case .Keep: return .Clear
            }
        }
    }

    var operationMode: EnOperationMode = .Swipe
    var extraMode: EnOnOff = .Off
    var debugMode: EnOnOff = .Off
    var resetSetting: EnSetting = .Clear
    var language: EnLanguage = .Japanese

    var highScore = 0
    var score = 0
    var numberOfPlayers = 0
    var round = 0
    var credit = 0

    var score_extendPlayer: Int = 0
    var score_extendedPlayer: Bool = false
    
    var numberOfFeeds: Int = 0
    var playerMiss: Bool = false
    var numberOfFeedsEatedByMiss: Int = 0
    var numberOfFeedsEated: Int = 0
    var numberOfFeedsRemaingToSpurt: Int = 0
    var numberOfFeedsToAppearSpecialTarget: Int = 0
    var kindOfSpecialTarget: CgSpecialTarget.EnSpecialTarget = .None
    
    var ghostPts: CgScorePts.EnScorePts = .pts100

    var levelOfSpeed: EnLevel = .Level_A
    var levelOfAppearance: EnLevel = .Level_A
    var timeWithPower: Int = 0
    var timeNotToEat: Int = 0
    var intermission: Int = 0

    var demo: Bool = false
    var demoSequence: Int = 0
    var counterByFrame: Int = 0
    
    // ============================================================
    //  Settings
    // ============================================================

    let table_difficultySettings: [(round: Int, levelOfSpeed: EnLevel, timeWithPower: Int, numberOfFeedsRemaingToSpurt: Int, levelOfAppearance: EnLevel, kindOfSpecialTarget: CgSpecialTarget.EnSpecialTarget, timeNotToEat: Int, intermission: Int)] = [
            //round, speedLevel, PowerTime[ms], Spurtfeeds, GhostAppear, SpecialTarget, NoEatTime[ms], Intermission
            (     1,   .Level_A,          6000,         20,    .Level_A,      .Cherry,           4000,            0 ),
            (     2,   .Level_B,          5000,         30,    .Level_B,  .Strawberry,           4000,            1 ),
            (     3,   .Level_B,          4000,         40,    .Level_C,      .Orange,           3000,            0 ),
            (     4,   .Level_B,          3000,         40,    .Level_C,      .Orange,           3000,            0 ),
            (     5,   .Level_C,          2000,         40,    .Level_C,       .Apple,           3000,            2 ),
            (     6,   .Level_C,          5000,         50,    .Level_C,       .Apple,           3000,            0 ),
            (     7,   .Level_C,          2000,         50,    .Level_C,       .Melon,           3000,            0 ),
            (     8,   .Level_C,          2000,         50,    .Level_C,       .Melon,           3000,            0 ),
            (     9,   .Level_C,          1000,         60,    .Level_C,    .Galaxian,           3000,            3 ),
            (    10,   .Level_C,          5000,         60,    .Level_C,    .Galaxian,           3000,            0 ),
            (    11,   .Level_C,          2000,         60,    .Level_C,        .Bell,           3000,            0 ),
            (    12,   .Level_C,          1000,         80,    .Level_C,        .Bell,           3000,            0 ),
            (    13,   .Level_C,          1000,         80,    .Level_C,         .Key,           3000,            3 ),
            (    14,   .Level_C,          3000,         80,    .Level_C,         .Key,           3000,            0 ),
            (    15,   .Level_C,          1000,        100,    .Level_C,         .Key,           3000,            0 ),
            (    16,   .Level_C,          1000,        100,    .Level_C,         .Key,           3000,            0 ),
            (    17,   .Level_C,             0,        100,    .Level_C,         .Key,           3000,            3 ),
            (    18,   .Level_C,          1000,        100,    .Level_C,         .Key,           3000,            0 ),
            (    19,   .Level_C,             0,        100,    .Level_C,         .Key,           3000,            0 ),
            (    20,   .Level_C,             0,        100,    .Level_C,         .Key,           3000,            0 ),
            (    21,   .Level_C,             0,        100,    .Level_C,         .Key,           3000,            0 ),
            (    22,   .Level_D,             0,        100,    .Level_C,         .Key,           3000,            0 )
        ]

    let table_speedSettings: [ (eatNone: Int, eatFeed: Int, eatPow: Int, eatNoneInPow: Int, eatFeedInPow: Int, eatPowInPow: Int,
         ghost: Int, ghostInSpurt: Int, ghostInPow: Int, ghostInWarp: Int) ]
        = [
            // Level A
            ( eatNone: 16, eatFeed: 15, eatPow: 13, eatNoneInPow: 18, eatFeedInPow: 17, eatPowInPow: 15,
              ghost: 15, ghostInSpurt: 16, ghostInPow: 10, ghostInWarp: 8 ),
            // Level B
            ( eatNone: 18, eatFeed: 17, eatPow: 15, eatNoneInPow: 19, eatFeedInPow: 18, eatPowInPow: 16,
              ghost: 17, ghostInSpurt: 18, ghostInPow: 11, ghostInWarp: 9 ),
            // Level C
            ( eatNone: 20, eatFeed: 19, eatPow: 17, eatNoneInPow: 20, eatFeedInPow: 19, eatPowInPow: 17,
              ghost: 19, ghostInSpurt: 20, ghostInPow: 12, ghostInWarp: 10 ),
            // Level D
            ( eatNone: 18, eatFeed: 17, eatPow: 15, eatNoneInPow: 18, eatFeedInPow: 17, eatPowInPow: 15,
              ghost: 19, ghostInSpurt: 20, ghostInPow: 10, ghostInWarp: 9 )
        ]

    let table_operationInDemo: [ (frameCount: Int, direction: EnDirection) ] = [
        (9, .Left), (36, .Down), (61, .Right), (82, .Down), (109, .Right), (133, .Up), (162, .Right),
        (189, .Up), (215, .Right), (238, .Down), (261, .Right), (308, .Down), (335, .Left), (523, .Up),
        (555, .Right), (569, .Up), (609, .Left), (632, .Up), (648, .Right), (684, .Up), (732, .Left),
        (831, .Down), (864, .Left), (931, .Up), (948, .Left), (970, .Up), (1063, .Right), (1113, .Down),
        (1157, .Right), (1218, .Down)
    ]

    // ============================================================
    //  Initializer
    // ============================================================
    init() {
        self.highScore = UserDefaults.standard.integer(forKey: "HIGHDSCORE")
        if let value = EnOperationMode(rawValue: UserDefaults.standard.integer(forKey: "OPERATION")) { operationMode = value }
        if let value = EnOnOff(rawValue: UserDefaults.standard.integer(forKey: "EXTRA_MODE")) { extraMode = value }
        if let value = EnOnOff(rawValue: UserDefaults.standard.integer(forKey: "DEBUG_MODE")) { debugMode = value }
        if let value = EnLanguage(rawValue: UserDefaults.standard.integer(forKey: "LANGUAGE")) { language = value }
        if let value = EnSetting(rawValue: UserDefaults.standard.integer(forKey: "SETTING")) { resetSetting = value }
        if resetSetting == .Clear { resetConfiguration() }
    }

    // ============================================================
    //  General methods in this class
    // ============================================================

    func resetConfiguration() {
        highScore = 0
        operationMode = .Swipe
        extraMode = .Off
        debugMode = .Off
        language  = .English
        resetSetting = .Clear
    }

    func saveConfiguration() {
        UserDefaults.standard.set(highScore, forKey: "HIGHDSCORE")
        UserDefaults.standard.set(operationMode.rawValue, forKey: "OPERATION")
        UserDefaults.standard.set(extraMode.rawValue, forKey: "EXTRA_MODE")
        UserDefaults.standard.set(debugMode.rawValue, forKey: "DEBUG_MODE")
        UserDefaults.standard.set(language.rawValue, forKey: "LANGUAGE")
        UserDefaults.standard.set(resetSetting.rawValue, forKey: "SETTING")
    }
    
    func resetGame() {
        score = 0
        numberOfPlayers = 3
        round = 1
        score_extendPlayer = (language == .English) ? 20000 : 10000
        score_extendedPlayer = false
    }
        
    func resetRound() {
        playerMiss = false
        numberOfFeedsEatedByMiss = 0
        numberOfFeedsEated = 0
        numberOfFeedsToAppearSpecialTarget = 70
        resetGhostPts()
        setDifficulty()
    }
    
    func resetGhostPts() {
        ghostPts = .pts200
    }
    
    /// Set the flag of player miss
    func setPlayerMiss() {
        numberOfFeedsEatedByMiss = 0
        playerMiss = true
    }

    /// Update high score
    /// - Returns: If true, the high score has been updated.
    func updateHighScore()->Bool {
        let highScoreUpdated: Bool = score > highScore
        if highScoreUpdated { highScore = score }
        return highScoreUpdated
    }
    
    /// Update timing to appear special target
    func updateSpecialTargetAppeared() {
        numberOfFeedsToAppearSpecialTarget += 100
    }
    
    /// Set difficulty of the round
    func setDifficulty() {
        let index = demo ? 0 : round-1
        let count = table_difficultySettings.count
        let table = (index < count) ? table_difficultySettings[index] : table_difficultySettings[count-1]
        levelOfSpeed = table.levelOfSpeed
        timeWithPower = table.timeWithPower
        numberOfFeedsRemaingToSpurt = table.numberOfFeedsRemaingToSpurt
        levelOfAppearance = table.levelOfAppearance
        kindOfSpecialTarget = table.kindOfSpecialTarget
        timeNotToEat = table.timeNotToEat
        intermission = table.intermission            
    }
    
    /// Get player speed
    /// - Parameters:
    ///   - action: Action of player
    ///   - power: True is with power
    /// - Returns: Speed
    func getPlayerSpeed(action: CgPlayer.EnPlayerAction, with power: Bool ) -> Int {
        let index = levelOfSpeed.rawValue
        let count = table_speedSettings.count
        let table = (index < count) ? table_speedSettings[index] : table_speedSettings[count-1]

        switch action {
            case .Walking where !power : return table.eatNone
            case .Walking where  power : return table.eatNoneInPow
            case .EatingFeed where !power : return table.eatFeed
            case .EatingFeed where  power : return table.eatFeedInPow
            case .EatingPower where !power : return table.eatPow
            case .EatingPower where  power : return table.eatPowInPow
            case .EatingFruit where !power : return table.eatNone
            case .EatingFruit where  power : return table.eatNoneInPow
            default: return 16
        }
    }

    /// Get ghost speed
    /// - Parameter action: Action of ghost
    /// - Returns: Speed
    func getGhostSpeed(action: CgGhost.EnGhostAction) -> Int {
        let index = levelOfSpeed.rawValue
        let count = table_speedSettings.count
        let table = (index < count) ? table_speedSettings[index] : table_speedSettings[count-1]

        switch action {
            case .Walking: return table.ghost
            case .Spurting: return table.ghostInSpurt
            case .Frightened: return table.ghostInPow
            case .Warping: return table.ghostInWarp
            case .GoingOut: fallthrough
            case .Standby: return 8
            case .Escaping: return 32
            default: return 16
        }
    }

    /// Appearance timing level
    /// - Returns: Number of ghosts to go out
    func getNumberOfGhostsForAppearace() -> Int {
        let numberOfGhosts: Int
        // Miss Bypass Sequence
        if playerMiss {
            if numberOfFeedsEatedByMiss < 7 {
                numberOfGhosts = 1
            } else if numberOfFeedsEatedByMiss < 17 {
                numberOfGhosts = 2
            } else if numberOfFeedsEatedByMiss < 32 {
                numberOfGhosts = 3
            } else {
                playerMiss = false
                numberOfGhosts = getNumberOfGhostsForAppearace()
            }
        } else {
            switch levelOfAppearance {
                case .Level_A:
                    if numberOfFeedsEated < 30 {
                        numberOfGhosts = 2
                    } else if numberOfFeedsEated < 90 {
                        numberOfGhosts = 3
                    } else {
                        numberOfGhosts = 4
                    }
                case .Level_B:
                    if numberOfFeedsEated < 50 {
                        numberOfGhosts = 3
                    } else {
                        numberOfGhosts = 4
                    }
                case .Level_C: fallthrough
                default:
                    numberOfGhosts = 4
            }
        }
        return numberOfGhosts
    }
    
    /// Judgement of Wavy Attack of Ghosts
    /// - Parameter time: elapsed time from the start
    /// - Returns: True is to become chase mode
    func judgeGhostsWavyChase(time: Int) -> Bool {
        var chaseMode: Bool = false
        switch levelOfSpeed {
            case .Level_A:
                chaseMode = (time >= 7000 && time < 27000) || (time >= 34000 && time < 54000)
                         || (time >= 59000 && time < 79000) || (time >= 84000)
            case .Level_B:
                chaseMode = (time >= 7000 && time < 27000) || (time >= 34000 && time < 54000)
                         || (time >= 59000)
            case .Level_C: fallthrough
            case .Level_D:
                chaseMode = (time >= 5000 && time < 25000) || (time >= 30000 && time < 50000)
                         || (time >= 55000)
        }
        return chaseMode
    }
    
    /// Judgement of Blinky's Spurt
    /// - Returns: True is to spurt.
    func judgeBlinkySpurt() -> Bool {
        let feedsRemain: Int = numberOfFeeds - numberOfFeedsEated
        return (feedsRemain <= numberOfFeedsRemaingToSpurt)
    }
    
    /// Get player operation for demonstration
    /// - Returns: Direction
    func getOperationForDemo() -> EnDirection {
        guard(demoSequence < table_operationInDemo.count) else { return .None }
        let table = table_operationInDemo[demoSequence]
        var direction: EnDirection = .None
        if counterByFrame >= table.frameCount {
            direction = table.direction
            demoSequence += 1
        }
        return direction
    }

}
