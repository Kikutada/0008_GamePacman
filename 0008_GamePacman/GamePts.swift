//
//  GamePts.swift
//  0006_GamePlayTest
//
//  Created by Kikutada on 2020/09/03.
//  Copyright © 2020 Kikutada All rights reserved.
//

import Foundation

/// Points for score class derived from CgActor
class CgScorePts : CgActor {

    enum EnScorePts: Int {
        case pts100 = 0
        case pts200
        case pts300
        case pts400
        case pts500
        case pts700
        case pts800
        case pts1000
        case pts1600
        case pts2000
        case pts3000
        case pts5000
        case pts0

        func getScore() -> Int {
            switch self {
                case .pts100  : return 100
                case .pts200  : return 200
                case .pts300  : return 300
                case .pts400  : return 400
                case .pts500  : return 500
                case .pts700  : return 700
                case .pts800  : return 800
                case .pts1000 : return 1000
                case .pts1600 : return 1600
                case .pts2000 : return 2000
                case .pts3000 : return 3000
                case .pts5000 : return 5000
                case .pts0    : return 0
            }
        }

        func get2times() -> EnScorePts {
            switch self {
                case .pts100  : return .pts200
                case .pts200  : return .pts400
                case .pts400  : return .pts800
                case .pts800  : return .pts1600
                default : return self
            }
        }
        
        func getTextures() -> (Int, Int) {
            switch self {
                case .pts100  : return (16*9   , 0)
                case .pts200  : return (16*8   , 0)
                case .pts300  : return (16*9+1 , 0)
                case .pts400  : return (16*8+1 , 0)
                case .pts500  : return (16*9+2 , 0)
                case .pts700  : return (16*9+3 , 0)
                case .pts800  : return (16*8+2 , 0)
                case .pts1000 : return (16*9+4 , 16*9+5)
                case .pts1600 : return (16*8+3 , 0)
                case .pts2000 : return (16*10+4, 16*10+5)
                case .pts3000 : return (16*11+4, 16*11+5)
                case .pts5000 : return (16*12+4, 16*12+5)
                case .pts0    : return (16*9   , 0)     //
            }
        }
    }

    private var ptsNumber: EnScorePts = .pts0
    private var timer_disappearPts: CbTimer!

    override init(binding object: CgSceneFrame, deligateActor: ActorDeligate) {
        super.init(binding: object, deligateActor: deligateActor)
        timer_disappearPts = CbTimer(binding: self)
        actor = .Pts
    }
        
    // ============================================================
    //   Core operation methods for actor
    //  - Sequence: reset()->start()->update() called->stop()
    // ============================================================
    
    /// Reset
    override func reset() {
        super.reset()
    }
    
    /// Start
    override func start() {
        super.start()
        timer_disappearPts.start()

        let textures: (Int,Int) = ptsNumber.getTextures()
        sprite.draw(sprite_number, x: position.x, y: position.y, texture: textures.0)
        if  textures.1 != 0 {
            sprite.draw(sprite_number+1, x: position.x+16, y: position.y, texture: textures.1)
        }
    }

    /// Update handler
    /// - Parameter interval: Interval time(ms) to update
    override func update(interval: Int) {
        if timer_disappearPts.isEventFired() {
            stop()
        }
    }
    
    /// Stop
    override func stop() {
        super.stop()
        timer_disappearPts.reset()

        sprite.clear(sprite_number)
        if ptsNumber.getTextures().1 != 0 {
            sprite.clear(sprite_number+1)
        }
    }
    
    // ============================================================
    //  General methods in this class
    // ============================================================

    func start(kind: EnScorePts, position at: CgPosition, interval time: Int) {
        ptsNumber = kind
        timer_disappearPts.set(interval: time)
        self.position.set(at)
        start()
    }
    
}

/// Points for score Manager
class CgScorePtsManager: CbContainer {

    private let firstSpriteNumber: Int = CgActor.EnActor.Pts.getSpriteNumber()
    private let numberOfActors: Int = 5
    
    private var actors: [CgScorePts] = []
    private var doings: [CgScorePts] = []

    init(binding object: CgSceneFrame, deligateActor: ActorDeligate) {
        super.init(binding: object)
        for i in 0 ..< numberOfActors {
            let actor: CgScorePts = CgScorePts(binding: object, deligateActor: deligateActor)
            actor.sprite_number = firstSpriteNumber+i*2
            actors.append(actor)
        }
    }
    
    /// Reset
    func reset() {
        for each in actors {
            each.reset()
        }
        self.enabled = false
    }
    
    /// Start to draw Pts
    /// - Parameters:
    ///   - kind: Kind of pts
    ///   - position: Position to draw
    ///   - time: Time to disappear
    func start(kind: CgScorePts.EnScorePts, position: CgPosition, interval time: Int) {
        let actor: CgScorePts

        if actors.count == 0 {
            actor = doings.remove(at: 0)
            actor.stop()
        } else {
            actor = actors.remove(at: 0)
        }
        actor.start(kind: kind, position: position, interval: time)
        doings.append(actor)
        self.enabled = true
    }
    
    /// Update handler
    /// - Parameter interval: Interval time(ms) to update
    override func update(interval: Int) {
        for each in doings {
            if !each.enabled {
                actors.append(each)
                doings.remove(at: 0)
            }
        }

        if doings.count == 0 {
            enabled = false
        }
    }
    
    /// Stop
    func stop() {
        for each in doings {
            each.stop()
            actors.append(each)
            doings.remove(at: 0)
        }
        self.enabled = false
    }

}
