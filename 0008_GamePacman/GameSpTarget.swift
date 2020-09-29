//
//  GameSpTarget.swift
//  0006_GamePlayTest
//
//  Created by Kikutada on 2020/09/03.
//  Copyright © 2020 Kikutada All rights reserved.
//

import Foundation

/// Special Target class
class CgSpecialTarget : CgActor {

    enum EnSpecialTarget: Int {
        case Cherry
        case Strawberry
        case Orange
        case Apple
        case Melon
        case Galaxian
        case Bell
        case Key
        case None

        func getScorePts() -> CgScorePts.EnScorePts {
            switch self {
                case .Cherry:     return .pts100
                case .Strawberry: return .pts300
                case .Orange:     return .pts500
                case .Apple:      return .pts700
                case .Melon:      return .pts1000
                case .Galaxian:   return .pts2000
                case .Bell:       return .pts3000
                case .Key:        return .pts5000
                case .None:       return .pts0
            }
        }

        func getTexture() -> Int {
            switch self {
                case .Cherry:     return 16*3+2
                case .Strawberry: return 16*3+3
                case .Orange:     return 16*3+4
                case .Apple:      return 16*3+5
                case .Melon:      return 16*3+6
                case .Galaxian:   return 16*3+7
                case .Bell:       return 16*3+8
                case .Key:        return 16*3+9
                case .None:       return 16*3+10
            }
        }
    }

    private var kindOfSpecialTarget: EnSpecialTarget = .None
    private var timer_disappearSpecialTarget: CbTimer!

    override init(binding object: CgSceneFrame, deligateActor: ActorDeligate) {
        super.init(binding: object, deligateActor: deligateActor)
        timer_disappearSpecialTarget = CbTimer(binding: self)
        actor = .SpecialTarget
        sprite_number = actor.getSpriteNumber()
    }

    // ============================================================
    //   Core operation methods for actor
    //  - Sequence: reset()->start()->update() called->stop()
    // ============================================================

    /// Reset special target state.
    override func reset() {
        super.reset()
        timer_disappearSpecialTarget.set(interval: 10000) // 10s
        timer_disappearSpecialTarget.reset()
        position.set(column: 13, row: 15, dx: 4)
    }
    
    /// Start to draw special target at the specified position.
    override func start() {
        super.start()
        timer_disappearSpecialTarget.start()
        deligateActor.setTile(column: position.column, row: position.row, value: .Fruit)
        sprite.draw(sprite_number, x: position.x, y: position.y, texture: kindOfSpecialTarget.getTexture())
    }

    /// Update handler
    /// - Parameter interval: Interval time(ms) to update
    override func update(interval: Int) {
        if timer_disappearSpecialTarget.isEventFired() {
            stop()
        }
    }
    
    /// Stop drawing special target.
    override func stop() {
        super.stop()
        timer_disappearSpecialTarget.stop()
        deligateActor.setTile(column: position.column, row: position.row, value: .Road)
        sprite.clear(sprite_number)
    }

    // ============================================================
    //  General methods in this class
    // ============================================================

    func start(kind: EnSpecialTarget) {
        kindOfSpecialTarget = kind
        self.start()
    }

}

