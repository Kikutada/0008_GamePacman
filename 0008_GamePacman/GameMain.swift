//
//  GameMain.swift
//  0004_PlayerTest
//
//  Created by Kikutada on 2020/08/17.
//  Copyright © 2020 Kikutada All rights reserved.
//

import SpriteKit

/// Main sequence of game scene.
class CgGameMain : CgSceneFrame {

    enum EnMainMode: Int {
        case AttractMode = 0, CreditMode, WaitForStartButton, StartMode, PlayMode
    }

    enum EnSubMode: Int {
        case Character = 0, StartDemo, PlayDemo
    }

    private var scene_attractMode: CgSceneAttractMode!
    private var scene_creditMode: CgSceneCreditMode!
    private var scene_maze: CgSceneMaze!
    private var subMode: EnSubMode = .Character

    init(skscene: SKScene) {
        super.init()

        // Create SpriteKit managers.
        self.sprite = CgSpriteManager(view: skscene, imageNamed: "pacman16_16.png", width: 16, height: 16, maxNumber: 64)
        self.background = CgCustomBackgroundManager(view: skscene, imageNamed: "pacman8_8.png", width: 8, height: 8, maxNumber: 2)
        self.sound = CgSoundManager(binding: self, view: skscene)
        self.context = CgContext()

        scene_attractMode = CgSceneAttractMode(object: self)
        scene_creditMode = CgSceneCreditMode(object: self)
        scene_maze = CgSceneMaze(object: self)
    }

    /// Event handler
    /// - Parameters:
    ///   - sender: Message sender
    ///   - id: Message ID
    ///   - values: Parameters of message
    override func handleEvent(sender: CbObject, message: EnMessage, parameter values: [Int]) {
        if message == .Touch {
            if let mode: EnMainMode = EnMainMode(rawValue: getSequence()) {
                if mode == .AttractMode {
                    goToNextSequence()
                }
            }
        }
    }
    
    /// Handle sequence
    /// To override in a derived class.
    /// - Parameter sequence: Sequence number
    /// - Returns: If true, continue the sequence, if not, end the sequence.
    override func handleSequence(sequence: Int) -> Bool {
        guard let mode: EnMainMode = EnMainMode(rawValue: sequence) else { return false }

        switch mode {
            case .AttractMode: attarctMode()
            case .CreditMode: creditMode()
            case .WaitForStartButton:
                if !scene_creditMode.enabled {
                    goToNextSequence()
                }
            case .StartMode: startMode()
            case .PlayMode: playMode()
        }
        
        // Continue running sequence.
        return true
    }

    // ============================================================
    //  Execute each mode.
    // ============================================================

    func attarctMode() {
        switch subMode {
            case .Character:
                scene_attractMode.resetSequence()
                scene_attractMode.startSequence()
                subMode = .StartDemo

            case .StartDemo:
                if !scene_attractMode.enabled {
                    context.demo = true
                    sound.enableOutput(false)
                    scene_maze.resetSequence()
                    scene_maze.startSequence()
                    subMode = .PlayDemo
                }

            case .PlayDemo:
                if !scene_maze.enabled {
                    subMode = .Character
                }
        }
    }
    
    func creditMode() {
        context.demo = false
        if scene_attractMode.enabled {
            scene_attractMode.stopSequence()
            scene_attractMode.clear()
        }
        if scene_maze.enabled {
            scene_maze.stopSequence()
            scene_maze.clear()
        }

        context.credit += 1
        scene_creditMode.resetSequence()
        scene_creditMode.startSequence()
        sound.enableOutput(true)
        sound.playSE(.Credit)
        goToNextSequence()
    }
    
    func startMode() {
        context.credit -= 1
        scene_creditMode.stopSequence()
        scene_maze.resetSequence()
        scene_maze.startSequence()
        goToNextSequence()
    }

    func playMode() {
        if !scene_maze.enabled {
            subMode = .Character
            goToNextSequence(EnMainMode.AttractMode.rawValue)
        }
    }

}

/// CgCustomBackground creates animation textures by overriden extendTextures function.
class CgCustomBackgroundManager : CgBackgroundManager {
    
    /// String color for background
    /// Raw value is offset of colored alphabet.
    enum EnBgColor: Int {
        case White = 0
        case Red = 64
        case Purple = 128
        case Cyan = 192
        case Orange = 256
        case Yellow = 320
        case Pink = 384
        case Character = 512
        case Maze = 576
        case Blink = 640
    }

    override func extendTextures() -> Int {
        // Blinking power dot
        // Add its texture as #16*48.
        extendAnimationTexture(sequence: [595, 592], timePerFrame: 0.16)

        // Blinking "1" character
        extendAnimationTexture(sequence: [17, 0], timePerFrame: 0.26)
        
        // Blinking "U" character
        extendAnimationTexture(sequence: [53, 0], timePerFrame: 0.26)
        
        // Blinking "P" character
        extendAnimationTexture(sequence: [48, 0], timePerFrame: 0.26)

        return 4 // Number of added textures
    }
    
    /// Print string with color on a background at the specified position.
    /// - Parameters:
    ///   - number: Background control number between 0 to (maxNumber-1)
    ///   - color: Specified color
    ///   - column: Column coordinate for position
    ///   - row: Row coordinate for position
    ///   - string: String corresponded to texture numbers
    ///   - offset: Offset to add to texture number
    func print(_ number: Int, color: EnBgColor, column: Int, row: Int, string: String ) {
        let asciiOffset: Int = 16*2  // for offset of ASCII
        putString(number, column: column, row: row, string: string, offset: color.rawValue-asciiOffset)
    }
}
