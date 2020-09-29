//
//  GameSequences.swift
//  0003_GameArchTest
//
//  Created by Kikutada on 2020/08/12.
//  Copyright © 2020 Kikutada. All rights reserved.
//

import Foundation
import SpriteKit

let BG_WIDTH: Int = 28
let BG_HEIGHT: Int = 36

/// Based game scene class
/// This class has spritekit managers, game context and  some methods of printing messages.
 class CgSceneFrame: CbScene {

    var context: CgContext!

    var sprite: CgSpriteManager!
    var background: CgCustomBackgroundManager!
    var sound: CgSoundManager!

    convenience init(binding object: CbObject, context: CgContext, sprite: CgSpriteManager, background: CgCustomBackgroundManager, sound: CgSoundManager) {
        self.init(binding: object)
        self.context = context
        self.sprite = sprite
        self.background = background
        self.sound = sound
    }
    
    convenience init(object: CgSceneFrame) {
        self.init(binding: object, context: object.context, sprite: object.sprite, background: object.background, sound: object.sound)
    }

    func drawBackground() {
        background.draw(0, x: CGFloat(BG_WIDTH/2*8), y: CGFloat(BG_HEIGHT/2*8), columnsInWidth: BG_WIDTH, rowsInHeight: BG_HEIGHT)
    }

    func printFrame() {
        background.print(0, color: .White, column:  0, row: 35, string: "   1UP   HIGH SCORE         ")
        background.print(0, color: .White, column:  0, row: 34, string: "     00        00           ")
    }

    func printPlayerScore() {
        let str = String(format: "%6d0", context.score/10)
        background.print(0, color: .White, column: 0, row: 34, string: str)
    }

    func printHighScore() {
        let str = context.highScore == 0 ? "       " : String(format: "%7d", context.highScore)
        background.print(0, color: .White, column: 10, row: 34, string: str)
    }

    func printCredit() {
        let str = String(format: "%2d", context.credit)
        background.print(0, color: .White, column:  0, row:  0, string: "  CREDIT ")
        background.print(0, color: .White, column: 9, row: 0, string: str)
    }

    func printPlayers(appearance: Bool = true) {
        background.print(0, color: .White, column:2, row: 1, string: "         ")
        background.print(0, color: .White, column:2, row: 0, string: "         ")

        var n =  appearance ? context.numberOfPlayers-1 : context.numberOfPlayers

        if n > 0 {
            if n > 4 { n = 4 }
            for i in 0 ..< n {
                background.put(0, column: i*2+2, row: 0, columnsInwidth: 2, rowsInHeight: 2, textures: [0,1,16,17], offset: 32*16)
            }
        }
    }
    
    func printRounds() {

        let bg_patterns :[[Int]] = [
            [128,129,144,145], /* cherry */  [130,131,146,147], /* strawberry */
            [132,133,148,149], /* orange */  [134,135,150,151], /* apple */
            [136,137,152,153], /* melon  */  [138,139,154,155], /* ailen */
            [140,141,156,157], /* bell   */  [142,143,158,159]  /* key */
        ]
        
        let sequence_rounds: [Int] = [0,1,2,2,3,3,4,4,5,5,6,6,7,7,7,7,7,7,7]

        var i_start = 0
        var round = context.round
        
        if round > 19 {
            i_start = 12
        } else if round > 7 {
            i_start = round - 7
        }

        if round < 7 {
            background.print(0, color: .White, column:12, row: 1, string: "                ")
            background.print(0, color: .White, column:12, row: 0, string: "                ")
        } else {
            round = 7
        }
        
        for i in 0 ..< round {
            background.put(0, column: 24-i*2, row: 0, columnsInwidth: 2, rowsInHeight: 2, textures: bg_patterns[sequence_rounds[i_start+i]], offset: 26*16)
        }
    }

}

/// Attract mode
/// - The character explanation of ghosts
/// - Demonstrations of the turning back
/// - Score table
/// - When the power is turned on, there is no high score, 2 UP score, and round display
/// - After playing, the final player's score and fruits are displayed
class CgSceneAttractMode: CgSceneFrame {

    private var x_animationOfPlayer: CGFloat = 0
    private var x_animationOfGhost: CGFloat = 0
    private var count_animationOfGhost: Int = 0

    /// Handle sequence
    /// To override in a derived class.
    /// - Parameter sequence: Sequence number
    /// - Returns: If true, continue the sequence, if not, end the sequence.
    override func handleSequence(sequence: Int) -> Bool {
        switch sequence {
            case  0:
                drawBackground()
                clear()
                printFrame()
                printPlayerScore()
                printHighScore()
                printCredit()
                printRounds()
                background.print(0, color: .White, column:  7, row: 31, string: "CHARACTER / NICKNAME ")
                goToNextSequence(after: 848)

            case  1:
                sprite.draw(0, x: 5*8, y: 30*8-4, texture: 64)
                goToNextSequence(after: 848)

            case  2:
                if context.language == .English {
                    background.print(0, color: .Red, column:  8, row: 29, string: "-SHADOW")
                } else {
                    background.print(0, color: .Red, column:  8, row: 29, string: "OIKAKE----")
                }
                goToNextSequence(after: 480)

            case  3:
                if context.language == .English {
                    background.print(0, color: .Red, column: 18, row: 29, string: "\"BLINKY\"")
                } else {
                    background.print(0, color: .Red, column: 18, row: 29, string: "\"AKABEI\"")
                }
                goToNextSequence(after: 480)

            case  4:
                sprite.draw(1, x: 5*8, y: 27*8-4, texture: 80)
                goToNextSequence(after: 848)

            case  5:
                if context.language == .English {
                    background.print(0, color: .Purple, column:8, row: 26, string: "-SPEEDY")
                } else {
                    background.print(0, color: .Purple, column:8, row: 26, string: "MACHIBUSE--")
                }
                goToNextSequence(after: 480)

            case  6:
                background.print(0, color: .Purple, column:18, row: 26, string: "\"PINKY\"")
                goToNextSequence(after: 480)

            case  7:
                sprite.draw(2, x: 5*8, y: 24*8-4, texture: 96)
                goToNextSequence(after: 848)

            case  8:
                if context.language == .English {
                    background.print(0, color: .Cyan, column:8, row: 23, string: "-BASHFUL")
                } else {
                    background.print(0, color: .Cyan, column:8, row: 23, string: "KIMAGURE--")
                }
                goToNextSequence(after: 480)

            case  9:
                if context.language == .English {
                    background.print(0, color: .Cyan, column:18, row: 23, string: "\"INKY\"")
                } else {
                    background.print(0, color: .Cyan, column:18, row: 23, string: "\"AOSUKE\"")
                }
                goToNextSequence(after: 480)

            case 10:
                sprite.draw(3, x: 5*8, y: 21*8-4, texture: 112)
                goToNextSequence(after: 848)

            case 11:
                if context.language == .English {
                    background.print(0, color: .Orange, column:8, row: 20, string: "-POKEY")
                } else {
                    background.print(0, color: .Orange, column:8, row: 20, string: "OTOBOKE---")
                }
                goToNextSequence(after: 480)

            case 12:
                if context.language == .English {
                    background.print(0, color: .Orange, column:18, row: 20, string: "\"CLYDE\"")
                } else {
                    background.print(0, color: .Orange, column:18, row: 20, string: "\"GUZUTA\"")
                }
                goToNextSequence(after: 848)

            case 13:
                background.print(0, color: .White, column:12, row: 11, string: "10 ]^_")    // 10 pts
                background.print(0, color: .White, column:12, row:  9, string: "50 ]^_")    // 50 pts
                background.put(0, column: 10, row: 11, texture: 16*37+1)
                background.put(0, column: 10, row:  9, texture: 16*37+3)  // Power dot
                background.put(0, column:  4, row: 16, texture: 16*37+3)  // Power dot
                goToNextSequence(after: 848)

            case 14:
                if context.language == .English {
                    background.print(0, color: .Purple, column:4, row: 4, string: "@ 2020 HIWAY.KIKUTADA")
                } else {
                    background.print(0, color: .Purple, column:11, row: 4, string: "#$%&'()*")   // NAMACO
                }
                goToNextSequence(after: 848)

            case 15:
                background.put(0, column: 10, row:  9, texture: 16*48)  // Blinking power dot
                background.put(0, column:  4, row: 16, texture: 16*48)  // Blinking power dot
                goToNextSequence(after: 848)

            case 16:
                count_animationOfGhost = 0
                x_animationOfPlayer = 30*8
                x_animationOfGhost = 30*8
                sprite.startAnimation(4, sequence: [66,67], timePerFrame: 0.12, repeat: true)
                sprite.startAnimation(5, sequence: [82,83], timePerFrame: 0.12, repeat: true)
                sprite.startAnimation(6, sequence: [98,99], timePerFrame: 0.12, repeat: true)
                sprite.startAnimation(7, sequence: [114,115], timePerFrame: 0.12, repeat: true)
                sprite.startAnimation(8, sequence: [32,33,2], timePerFrame: 0.05, repeat: true)
                updatePosition()
                goToNextSequence()
           
            case 17:
                if x_animationOfPlayer > 37 {
                    x_animationOfPlayer -= 1.2
                    x_animationOfGhost -= 1.28
                } else {
                    background.put(0, column: 4, row: 16, texture: 0)
                    for i in count_animationOfGhost ..< 4 {
                        sprite.startAnimation(i+4, sequence: [72,73], timePerFrame: 0.12, repeat: true)
                    }
                    goToNextSequence()
                }
                updatePosition()

            case 18:
                x_animationOfPlayer -= 1.34
                x_animationOfGhost += 0.74
                if x_animationOfPlayer <= 34 {
                    sprite.startAnimation(8, sequence: [0,1,2], timePerFrame: 0.05, repeat: true)
                    goToNextSequence()
                }
                updatePosition()
            
            case 19:
                x_animationOfPlayer += 1.34
                x_animationOfGhost += 0.74
                if ( x_animationOfPlayer >= (x_animationOfGhost+CGFloat(count_animationOfGhost*16+28)) ) {
                    sprite.hide(8)
                    for i in count_animationOfGhost ..< 4 {
                        sprite.stopAnimation(i+4)
                    }
                    sprite.setTexture(count_animationOfGhost+4, texture: count_animationOfGhost+16*8)
                    goToNextSequence(after: 848)
                }
                updatePosition()
            
            case 20:
                sprite.hide(count_animationOfGhost+4)
                count_animationOfGhost += 1
                if count_animationOfGhost < 4 {
                    sprite.show(8)
                    for i in count_animationOfGhost ..< 4 {
                        sprite.startAnimation(i+4, sequence: [72,73], timePerFrame: 0.12, repeat: true)
                    }
                    goToNextSequence(19)
                } else {
                    goToNextSequence()
                }

            default:
                clear()
                // Stop and exit running sequence.
                return false
        }
        
        // Continue running sequence.
        return true
    }

    func clear() {
        background.fill(0, texture: 0)
        for i in 0 ..< 9 {
            sprite.stopAnimation(i)
            sprite.show(i)
            sprite.setDepth(i, zPosition: CGFloat(i))
            sprite.clear(i)
        }
    }
    
    func updatePosition() {
        sprite.setPosition(4, x: x_animationOfGhost+16*2, y: 17*8-4)
        sprite.setPosition(5, x: x_animationOfGhost+16*3, y: 17*8-4)
        sprite.setPosition(6, x: x_animationOfGhost+16*4, y: 17*8-4)
        sprite.setPosition(7, x: x_animationOfGhost+16*5, y: 17*8-4)
        sprite.setPosition(8, x: x_animationOfPlayer,     y: 17*8-4)
    }
    
}

/// #1 Intermission (M1:Manga)
/// Pacman is chased by a red ghost, then grows up and chases the frightened ghost.
class CgSceneIntermission1: CgSceneFrame {

    private var x_animationOfPlayer: CGFloat = 0
    private var x_animationOfGhost: CGFloat = 0

    /// Handle sequence
    /// To override in a derived class.
    /// - Parameter sequence: Sequence number
    /// - Returns: If true, continue the sequence, if not, end the sequence.
    override func handleSequence(sequence: Int) -> Bool {
        switch sequence {
            case  0:
                clear()
                printRounds()
                x_animationOfPlayer = 240
                x_animationOfGhost = 240
                sprite.startAnimation(0, sequence: [66,67], timePerFrame: 0.12, repeat: true)
                sprite.startAnimation(1, sequence: [32,33,2], timePerFrame: 0.05, repeat: true)
                sprite.setPosition(0, x: x_animationOfGhost+32, y: 17*8-4)
                sprite.setPosition(1, x: x_animationOfPlayer, y: 17*8-4)
                sound.playBGM(.Intermission)
                goToNextSequence(after: 20*16)
            
            case 1:
                if x_animationOfGhost > -48 {
                    x_animationOfPlayer -= 1.5
                    x_animationOfGhost -= 1.6
                } else {
                    sprite.startAnimation(0, sequence: [72,73], timePerFrame: 0.12, repeat: true)
                    goToNextSequence(after: 960)
                }
                updatePosition()

            case  2:
                x_animationOfGhost += 0.74
                if x_animationOfGhost >= 80 {
                    sprite.startAnimation(1, sequence: [18, 20, 22], timePerFrame: 0.12, repeat: true)
                    sprite.startAnimation(2, sequence: [19, 21, 23], timePerFrame: 0.12, repeat: true)
                    sprite.startAnimation(3, sequence: [34, 36, 38], timePerFrame: 0.12, repeat: true)
                    sprite.startAnimation(4, sequence: [35, 37, 39], timePerFrame: 0.12, repeat: true)
                    goToNextSequence()
                }
                updatePosition()
            
            case  3:
                x_animationOfGhost += 0.74
                x_animationOfPlayer += 1.34
                if x_animationOfPlayer >= 240 {
                    goToNextSequence()
                }
                updatePosition()
                
            case  4:
                sound.stopBGM()
                goToNextSequence(after: 1008)
                    
            default:
                clear()
                // Stop and exit running sequence.
                return false
        }

        // Continue running sequence.
        return true
    }
    
    func clear() {
        background.fill(0, texture: 0)
        for i in 0 ..< 5 {
            sprite.stopAnimation(i)
            sprite.show(i)
            sprite.clear(i)
        }
    }

    func updatePosition() {
        sprite.setPosition(0, x: x_animationOfGhost+32,  y: 17*8-4)
        sprite.setPosition(1, x: x_animationOfPlayer,    y: 17*8-4)
        sprite.setPosition(2, x: x_animationOfPlayer+16, y: 17*8-4)
        sprite.setPosition(3, x: x_animationOfPlayer,    y: 17*8+12)
        sprite.setPosition(4, x: x_animationOfPlayer+16, y: 17*8+12)
    }
}

/// #2 Intermission (M2:Manga)
/// A red ghost's clothes are caught by a needle and can be torn.
class CgSceneIntermission2: CgSceneFrame {

    private var x_animationOfPlayer: CGFloat = 0
    private var x_animationOfGhost: CGFloat = 0

    /// Handle sequence
    /// To override in a derived class.
    /// - Parameter sequence: Sequence number
    /// - Returns: If true, continue the sequence, if not, end the sequence.
    override func handleSequence(sequence: Int) -> Bool {
        switch sequence {
            case  0:
                clear()
                background.fill(0, texture: 0)
                printRounds()
                sprite.draw(0, x: 8*16, y: 17*8-4, texture: 104) // needle
                sound.playBGM(.Intermission)
                goToNextSequence(after: 20*16)

            case  1:
                x_animationOfPlayer = 8*30
                sprite.startAnimation(2, sequence: [32,33,2], timePerFrame: 0.05, repeat: true)
                sprite.setPosition(2, x: x_animationOfPlayer, y: 17*8-4)
                goToNextSequence(after: 16)
            
            case  2:
                if x_animationOfPlayer > 14*8 {
                    updatePosition()
                } else {
                    x_animationOfGhost = 8*30
                    sprite.startAnimation(3, sequence: [66,67], timePerFrame: 0.12, repeat: true)
                    sprite.setPosition(3, x: x_animationOfGhost, y: 17*8-4)
                    goToNextSequence()
                }
                
            case  3:
                if x_animationOfGhost > 16*8+2 {
                    x_animationOfGhost -= 1.0
                    updatePosition()
                } else {
                    sprite.draw(0, x: 14*8+17, y: 17*8-4, texture: 105)
                    sprite.startAnimation(3, sequence: [66,67], timePerFrame: 0.3, repeat: true)
                    goToNextSequence()
                }

            case  4:
                if x_animationOfGhost > 16*8 {
                    x_animationOfGhost -= 0.5
                    updatePosition()
                } else {
                    sprite.draw(0, x: 14*8+17, y: 17*8-4, texture: 106)
                    goToNextSequence()
                }

            case  5:
                if x_animationOfGhost > 14*8+12 {
                    x_animationOfGhost -= 0.2
                    updatePosition()
                } else {
                    sprite.draw(0, x: 14*8+17, y: 17*8-4, texture: 106)
                    sprite.draw(1, x: 14*8+17, y: 17*8-4, texture: 107)
                    goToNextSequence()
                }

            case  6:
                if x_animationOfGhost > 14*8+6 {
                    x_animationOfGhost -= 0.1
                    sprite.setPosition(0, x: x_animationOfGhost+5, y: 17*8-4)
                    updatePosition()
                } else {
                    goToNextSequence()
                }

            case 7:
                sprite.stopAnimation(3)
                goToNextSequence(after: 1008)

            case  8:
                sprite.draw(0, x: 8*16, y: 17*8-4, texture: 108) // Ghost with needle
                sprite.hide(1)
                sprite.draw(3, x: x_animationOfGhost, y: 17*8-4, texture: 120) //　Ghost
                goToNextSequence(after: 1408)

            case  9:
                sprite.draw(3, x: x_animationOfGhost, y: 17*8-4, texture: 121) //　Ghost
                goToNextSequence(after: 1408)

            case 10:
                sound.stopBGM()
                goToNextSequence(after: 1508)

            default:
                clear()
                // Stop and exit running sequence.
                return false
            }
                
        // Continue running sequence.
        return true
    }

    func clear() {
        background.fill(0, texture: 0)
        for i in 0 ..< 4 {
            sprite.stopAnimation(i)
            sprite.show(i)
            sprite.setDepth(i, zPosition: CGFloat(i))
            sprite.clear(i)
        }
    }

    func updatePosition() {
        if x_animationOfPlayer > -32 {
            x_animationOfPlayer -= 1.0
            sprite.setPosition(2, x: x_animationOfPlayer, y: 17*8-4)
        }
        sprite.setPosition(3, x: x_animationOfGhost, y: 17*8-4)
    }
}

/// #3 Intermission (M3:Manga)
/// The undressed  ghost drags his clothes and runs away.
class CgSceneIntermission3: CgSceneFrame {

    private var x_animationOfPlayer: CGFloat = 0
    private var x_animationOfGhost: CGFloat = 0

    /// Handle sequence
    /// To override in a derived class.
    /// - Parameter sequence: Sequence number
    /// - Returns: If true, continue the sequence, if not, end the sequence.
    override func handleSequence(sequence: Int) -> Bool {
        switch sequence {
            case  0:
                clear()
                printRounds()
                x_animationOfPlayer = 8*30
                sprite.startAnimation(0, sequence: [32,33,2], timePerFrame: 0.05, repeat: true)

                x_animationOfGhost = 8*35
                sprite.startAnimation(1, sequence: [122,123], timePerFrame: 0.12, repeat: true)
                sprite.hide(2)
                updatePosition()
                sound.playBGM(.Intermission)
                goToNextSequence(after: 320)

            case  1:
                x_animationOfPlayer -= 1.4
                x_animationOfGhost -= 1.4
                if x_animationOfGhost > -32 {
                    updatePosition()
                } else {
                    sprite.startAnimation(1, sequence: [138,139], timePerFrame: 0.12, repeat: true)
                    sprite.startAnimation(2, sequence: [136,137], timePerFrame: 0.12, repeat: true)
                    sprite.show(2)
                    goToNextSequence(after: 1008)
                }

            case  2:
                x_animationOfGhost += 1.4
                if x_animationOfGhost < 8*32 {
                    updatePosition()
                } else {
                    sound.stopBGM()
                    goToNextSequence(after: 2512)
                }

            default:
                clear()
                // Stop and exit running sequence.
                return false
        }

        // Continue running sequence.
        return true
    }
                
    func clear() {
        background.fill(0, texture: 0)
        for i in 0 ..< 3 {
            sprite.stopAnimation(i)
            sprite.show(i)
            sprite.setDepth(i, zPosition: CGFloat(i))
            sprite.clear(i)
        }
    }

    func updatePosition() {
        sprite.setPosition(0, x: x_animationOfPlayer , y: 17*8-4)
        sprite.setPosition(1, x: x_animationOfGhost  , y: 17*8-4)
        sprite.setPosition(2, x: x_animationOfGhost-8, y: 17*8-4)
    }
}

/// Credit Mode
class CgSceneCreditMode : CgSceneFrame {

    enum EnEvent: Int {
        case EnterConfig = 3
        case Operation = 5
        case ExtraMode = 6
        case DebugMode = 7
        case Language = 8
        case ResetSetting = 9
        case ExitConfig = 10
        case None
    }

    private let table_enterConfiguration: [(Int,Int,Int,Int,EnEvent)] = [
        (  26, 34, 28, 36, .EnterConfig)
    ]

    private let table_setConfiguration: [(Int,Int,Int,Int,EnEvent)] = [
        (  26, 34, 28, 36, .ExitConfig),
        (   4, 25, 28, 27, .Operation),
        (   4, 20, 28, 22, .ExtraMode),
        (   4, 15, 28, 17, .DebugMode),
        (   4, 10, 28, 12, .Language),
        (   4,  5, 28,  7, .ResetSetting)
    ]

    private var table_search: [(column0:Int,row0:Int,column1:Int,row1:Int,event:EnEvent)] = []
    private var configMode: Bool = false

    /// Event handler
    /// - Parameters:
    ///   - sender: Message sender
    ///   - id: Message ID
    ///   - values: Parameters of message
    override func handleEvent(sender: CbObject, message: EnMessage, parameter values: [Int]) {
        if message == .Touch {
            let position = CgPosition.init(x: CGFloat(values[0]), y: CGFloat(values[1]))
            let event = search(column: position.column, row: position.row)
            if event == .None {
                if !configMode {
                    stopSequence()
                }
            } else {
                goToNextSequence(event.rawValue)
            }
        }
    }

    /// Handle sequence
    /// To override in a derived class.
    /// - Parameter sequence: Sequence number
    /// - Returns: If true, continue the sequence, if not, end the sequence.
    override func handleSequence(sequence: Int) -> Bool {
        switch sequence {
            case  0:
                configMode = false
                table_search = []
                clear()
                printFrame()
                printPlayerScore()
                printHighScore()
                printCredit()
                printRounds()
                background.print(0, color: .Orange, column: 6, row: 19, string: "PUSH START BUTTON")
                background.print(0, color: .Cyan, column: 8, row: 15, string: "1 PLAYER ONLY")

                if context.language == .English {
                    background.print(0, color: .Pink, column: 1, row: 11, string: "BONUS PAC-MAN FOR 20000 ]^_")
                    background.print(0, color: .Purple, column:4, row: 4, string: "@ 2020 HIWAY.KIKUTADA")
                } else {
                    background.print(0, color: .Pink, column: 1, row: 11, string: "BONUS PAC-MAN FOR 10000 ]^_")
                    background.print(0, color: .Purple, column: 7, row: 7, string: "@ #$%&'()*  2020")   // NAMACO
                }
                goToNextSequence(after: 60*16*2)
            
            case 1:
                table_search = table_enterConfiguration
                background.print(0, color: .White, column:  27, row: 35, string: "$")
                goToNextSequence()

            case 2:
                // wait for event
                break;

            case 3:
                configMode = true
                table_search = table_setConfiguration
                background.fill(0, texture: 0)
                printFrame()
                printPlayerScore()
                printHighScore()
                printCredit()
                background.print(0, color: .White, column: 27, row: 35, string: "#")
                background.print(0, color: .Red,   column:  8, row: 31, string: "CONFIGURATION")
                background.print(0, color: .White, column:  4, row: 26, string: "OPERATION")
                background.print(0, color: .White, column:  4, row: 21, string: "EXTRA MODE")
                background.print(0, color: .White, column:  4, row: 16, string: "DEBUG MODE")
                background.print(0, color: .White, column:  4, row: 11, string: "LANGUAGE")
                background.print(0, color: .White, column:  4, row:  6, string: "SETTING")
                print_operation(color: .Pink)
                print_extraMode(color: .Pink)
                print_debugMode(color: .Pink)
                print_language(color: .Pink)
                print_resetSetting(color: .Pink)
                goToNextSequence()

            case 4:
                // wait for event
                break;

            case 5: // operation
                context.operationMode = context.operationMode.getNext()
                print_operation(color: .Yellow)
                goToNextSequence(4)
                
            case 6: // ExtraMode/
                context.extraMode = context.extraMode.getNext()
                print_extraMode(color: .Yellow)
                goToNextSequence(4)

            case 7: // DebugMode
                context.debugMode = context.debugMode.getNext()
                print_debugMode(color: .Yellow)
                goToNextSequence(4)

            case 8: // Language
                context.language = context.language.getNext()
                print_language(color: .Yellow)
                goToNextSequence(4)

            case 9: // ResetSetting
                context.resetSetting = context.resetSetting.getNext()
                print_resetSetting(color: .Yellow)
                goToNextSequence(4)

            case 10:
                context.saveConfiguration()
                goToNextSequence(0)

            default:
                clear()
                // Stop and exit running sequence.
                return false
        }
        
        return true
    }
    
    func clear() {
        background.fill(0, texture: 0)
    }

    func print_operation(color: CgCustomBackgroundManager.EnBgColor) {
        let str = context.operationMode.getString()
        background.print(0, color: color, column: 16, row: 26, string: str)
    }

    func print_extraMode(color: CgCustomBackgroundManager.EnBgColor) {
        let str = context.extraMode.getString()
        background.print(0, color: color, column: 16, row: 21, string: str)
    }

    func print_debugMode(color: CgCustomBackgroundManager.EnBgColor) {
        let str = context.debugMode.getString()
        background.print(0, color: color, column: 16, row: 16, string: str)
    }

    func print_language(color: CgCustomBackgroundManager.EnBgColor) {
        let str = context.language.getString()
        background.print(0, color: color, column: 16, row: 11, string: str)
    }

    func print_resetSetting(color: CgCustomBackgroundManager.EnBgColor) {
        let str = context.resetSetting.getString()
        background.print(0, color: color, column: 16, row: 6, string: str)
    }

    func search(column: Int, row: Int) -> EnEvent {
        var event: EnEvent = .None
        for i in 0 ..< table_search.count {
            let t = table_search[i]
            if (t.column0 <= column && t.row0 <= row) && (t.column1 >= column && t.row1 >= row) {
                event = t.event
                break
            }
        }
        return event
    }

}
