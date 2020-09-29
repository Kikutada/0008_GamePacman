//
//  SoundManager.swift
//  Sound Manager Class for SpriteKit
//
//  Created by Kikutada on 2020/08/11.
//  Copyright © 2020 Kikutada. All rights reserved.
//

import Foundation
import SpriteKit

/// Sound management class plays sound with SpriteKit.
class CgSoundManager: CbContainer {

    /// Kind of sound items to play back
    enum EnKindOfSound: Int {
        case EatFeed = 0
        case EatFruit
        case EatGhost
        case Miss
        case ExtraPacman
        case Credit
        case BgmNormal
        case BgmSpurt1
        case BgmSpurt2
        case BgmSpurt3
        case BgmSpurt4
        case BgmPower
        case BgmEscaping
        case Beginning
        case Intermission
    }

    /// List of sound files to load
    private let table_urls: [[(resourceName: String, typeName: String, interval: Int)]] = [
        [ ("16_pacman_eatdot_256ms", "wav", 239) ],
        [ ("16_pacman_eatfruit_438ms", "wav", 438) ],
        [ ("16_pacman_eatghost_544ms", "wav", 544) ],
        [ ("16_pacman_miss_1536ms", "wav", 1536) ],
        [ ("16_pacman_extrapac_1952ms", "wav", 1952) ],
        [ ("16_credit_224ms", "wav", 224) ],
        [ ("16_BGM_normal_400ms", "wav", 400) ],
        [ ("16_BGM_spurt1_352ms", "wav", 352) ],
        [ ("16_BGM_spurt2_320ms", "wav", 320) ],
        [ ("16_BGM_spurt3_592ms", "wav", 592) ],
        [ ("16_BGM_spurt4_512ms", "wav", 512) ],
        [ ("16_BGM_power_400ms", "wav", 400) ],
        [ ("16_BGM_return_528ms", "wav", 528) ],
        [ ("16_pacman_beginning_4224ms", "wav", 4224) ],
        [ ("16_pacman_intermission_5200ms", "wav", 5200) ]
    ]

    private var view: SKScene?
    private var actions: [SKAction] = []
    private var table_playingTime: [Int] = []
    private var soundEnabled = true
    
    /// Adjustment time for processing to play sound
    private let triggerThresholdTime: Int = 48 //ms

    private var bgmEnabled: Bool = false
    private var bgmNumber: Int = -1
    private var bgmTime: Int = 0
    
    /// Create and initialize a sound manager object
    /// - Parameters:
    ///   - view: SKScene object that organizes all of the active SpriteKit content
    ///   - object: Object to bind self
    init(binding object: CbObject, view: SKScene) {
        super.init(binding: object)
        self.view = view
        table_playingTime = Array<Int>(repeating: 0, count: table_urls.count)

        for t in table_urls {
            appendSoundResource(resourceName: t[0].resourceName, typeName: t[0].typeName)
        }
        reset()
    }
    
    /// Append sound resources to SpriteKit
    /// - Parameters:
    ///   - resourceName: File name for sound resource
    ///   - typeName: Type name for sound resource
    private func appendSoundResource(resourceName: String, typeName: String) {
        let fileName = resourceName+"."+typeName
        let sound: SKAction = SKAction.playSoundFileNamed(fileName, waitForCompletion: false)
        actions.append(sound)
    }
    
    /// Update sound manager
    /// - Parameter interval: Interval time to update
    override func update(interval: Int) {
        // Update time to play back BGM.
        if  bgmEnabled && bgmTime > 0 {
            bgmTime -= interval
            if bgmTime <= 0 {
                let table = table_urls[bgmNumber]
                bgmTime = table[0].interval
                view?.run(actions[bgmNumber])
            }
        }

        // Update time to play back sound.
        for i in 0 ..< table_urls.count {
            if table_playingTime[i] > 0 {
                table_playingTime[i] -= interval
            }
        }
    }
    
    /// Reset sound manager
    func reset() {
        soundEnabled = true
        bgmEnabled = false
        bgmNumber = -1
        bgmTime = 0

        for i in 0 ..< table_urls.count {
            table_playingTime[i] = 0
        }
    }

    /// Enable or disable to output sound
    /// - Parameter enabled: True enables to output sound.  False disables
    func enableOutput(_ enabled: Bool) {
        soundEnabled = enabled
    }

    /// Play back a specified sound
    /// If the specified item is playing back, it will not be played back
    /// - Parameter number: Kind of sound items to play back
    func playSE(_ number: EnKindOfSound) {
        guard soundEnabled && number.rawValue < actions.count else { return }

        let _number = number.rawValue
        if table_playingTime[_number] <= triggerThresholdTime {
            let table = table_urls[_number]
            table_playingTime[_number] = table[0].interval
            view?.run(actions[_number])
        }
    }
    
    /// Stop the specified sound
    /// - Parameter number: Kind of sound items to play back
    func stopSE(_ number: EnKindOfSound) {
        guard number.rawValue < actions.count else { return }

        table_playingTime[number.rawValue] = 0
    }

    /// Play back BGM
    /// This method plays a specified sound item repeatedly.
    /// If the specified item is playing back, it will not be played back.
    /// - Parameter number: Kind of sound items to play back
    func playBGM(_ number: EnKindOfSound) {
        guard soundEnabled && number.rawValue < actions.count else { return }
        guard !bgmEnabled || number.rawValue != bgmNumber else { return }

        bgmNumber = number.rawValue
        if bgmTime <= triggerThresholdTime {
            bgmEnabled = true
            let table = table_urls[bgmNumber]
            bgmTime = table[0].interval
            view?.run(actions[bgmNumber])
        }
    }
    
    /// Stop BGM
    func stopBGM() {
        bgmEnabled = false
        bgmTime = 0
    }
    
}

