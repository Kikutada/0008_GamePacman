//
//  GameActor.swift
//  0004_PlayerTest
//
//  Created by Kikutada on 2020/08/17.
//  Copyright © 2020 Kikutada All rights reserved.
//

import Foundation
import UIKit

/// List the directions in which the character moves
enum EnDirection: Int {
    case None = -2
    case Stop   = -1
    case Right  = 0
    case Left   = 1
    case Up     = 2
    case Down   = 3

    func getHorizaontalDelta() -> Int {
        switch self {
            case .None:     return 0
            case .Stop:     return 0
            case .Up:       return 0
            case .Down:     return 0
            case .Left:     return -1
            case .Right:    return +1
        }
    }
    
    func getVerticalDelta() -> Int {
        switch self {
            case .None:     return 0
            case .Stop:     return 0
            case .Up:       return +1
            case .Down:     return -1
            case .Left:     return 0
            case .Right:    return 0
        }
    }
    
    func getReverse() -> EnDirection {
        switch self {
            case .None:     return .None
            case .Stop:     return .Stop
            case .Up:       return .Down
            case .Down:     return .Up
            case .Left:     return .Right
            case .Right:    return .Left
        }
    }
    
    func getRandom() -> EnDirection {
        switch Int.random(in: 1..<5) {
            case 1: return .Up
            case 2: return .Down
            case 3: return .Left
            case 4: return .Right
            default: return .Stop
        }
    }
    
    func getClockwise() -> EnDirection {
        switch self {
            case .None:     return .None
            case .Stop:     return .Stop
            case .Up:       return .Right
            case .Down:     return .Left
            case .Left:     return .Up
            case .Right:    return .Down
        }
    }
    
    func getCounterClockwise() -> EnDirection {
        switch self {
            case .None:     return .None
            case .Stop:     return .Stop
            case .Up:       return .Left
            case .Down:     return .Right
            case .Left:     return .Down
            case .Right:    return .Up
        }
    }
}


/// Position class of the moving character
class CgDirection {
    var currentDirection: EnDirection = .None
    var nextDirection: EnDirection = .None
    
    func reset() {
        currentDirection = .Stop
        nextDirection = .Stop
    }

    func get() -> EnDirection {
        return currentDirection
    }

    func getNext() -> EnDirection {
        return nextDirection
    }

    func set(to direction: EnDirection) {
        nextDirection = direction
    }
    
    func update() {
        if nextDirection != .Stop {
            currentDirection = nextDirection
        }
    }

    func isChanging() -> Bool {
        return ( currentDirection != nextDirection )
    }
}

/// Position class of the moving character
class CgPosition {

    let CG_X_ORIGIN: Int = -4
    let CG_Y_ORIGIN: Int = -4

    let SPEED_UNIT: Int = 16

    var row: Int = 0, column: Int = 0
    var dx:  Int = 0, dy: Int = 0
    var dxf: Int = 0, dyf: Int = 0
    
    var amountMoved: Int = 0

    
    var x: CGFloat {
        get {
            return CGFloat(column * MAZE_UNIT + dx - CG_X_ORIGIN)
        }
        set {
            column = (Int(newValue) + CG_X_ORIGIN) / MAZE_UNIT
            dx     = (Int(newValue) + CG_X_ORIGIN) % MAZE_UNIT
            dxf    = 0
        }
    }

    var y: CGFloat {
        get {
            return CGFloat(row * 8 + dy - CG_Y_ORIGIN)
        }
        set {
            row = (Int(newValue) + CG_Y_ORIGIN) / MAZE_UNIT
            dy  = (Int(newValue) + CG_Y_ORIGIN) % MAZE_UNIT
            dyf = 0
        }
    }

    init() {
        self.set(column: 0, row: 0)
    }

    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }

    init(column: Int, row: Int) {
        self.set(column: column, row: row)
    }

    func set(column: Int, row: Int, dx: Int = 0, dy: Int = 0) {
        self.column = column
        self.row = row
        self.dx = dx
        self.dy = dy
        self.dxf = 0
        self.dyf = 0
        self.amountMoved = 0
    }

    func set(_ position: CgPosition) {
        self.set(column: position.column, row: position.row, dx: position.dx, dy: position.dy)
    }

    func canMove(to direction: EnDirection)->Bool {
        return ( (direction == .Left || direction == .Right) && (dy == 0) ||
                 (direction ==   .Up || direction ==  .Down) && (dx == 0) )
    }

    func getAbsoluteDelta(to direction: EnDirection) -> Int {
        let delta: Int
        switch direction {
            case .Right: delta = dx > 0 ? dx : 0
            case .Left:  delta = dx < 0 ? -dx : 0
            case .Up:    delta = dy > 0 ? dy : 0
            case .Down:  delta = dy < 0 ? -dy : 0
            default:     delta = 0
        }
        return abs(delta)
    }

    func roundDown(to direction: EnDirection = .Stop) {
        switch direction {
            case .Right: dxf = 0
            case .Left:  dxf = 0
            case .Up:    dyf = 0
            case .Down:  dyf = 0
            case .Stop:  dxf = 0
                         dyf = 0
            default:     break
        }
    }

    /// Move every 1dot at a time in the direction.
    /// - Parameters:
    ///   - direction: Move in the direction
    ///   - speed: Speed amount
    /// - Returns: Remaining speed amount
    func move(to direction: EnDirection, speed: Int = 0) -> Int {

        var remainingSpeed: Int = 0
        var amountOfMovement: Int

        if speed >= SPEED_UNIT {
            amountOfMovement = SPEED_UNIT
            remainingSpeed = speed - SPEED_UNIT
        } else {
            amountOfMovement = speed
            remainingSpeed = 0
        }

        switch direction {
            case .Left:
                dxf -= amountOfMovement
                if dxf <= -SPEED_UNIT {
                    dxf += SPEED_UNIT
                    decrementHorizontal()
                    amountMoved += 1
            }
            case .Right:
                dxf += amountOfMovement
                if dxf >= SPEED_UNIT {
                    dxf -= SPEED_UNIT
                    incrementHorizontal()
                    amountMoved += 1
                }
            case .Down:
                dyf -= amountOfMovement
                if dyf <= -SPEED_UNIT {
                    dyf += SPEED_UNIT
                    decrementVertical()
                    amountMoved += 1
                }
            case .Up:
                dyf += amountOfMovement
                if dyf >= SPEED_UNIT {
                    dyf -= SPEED_UNIT
                    incrementVertical()
                    amountMoved += 1
                }

            case .Stop: fallthrough
            default:
                dxf = 0
                dyf = 0
        }
        
        return remainingSpeed
    }

    private func incrementHorizontal(value: Int = 1) {
        dx += value
        if dx >= MAZE_UNIT {
            column += 1
            dx = 0
            if column >= BG_WIDTH {  // warp tunnel
                column = 0
            }
        }
    }

    private func decrementHorizontal(value: Int = 1) {
        dx -= value
        if dx <= -MAZE_UNIT {
            column -= 1
            dx = 0
            if column < 0 {  // warp tunnel
                column = BG_WIDTH-1
            }
        }
    }

    private func incrementVertical(value: Int = 1) {
        dy += value
        if dy >= MAZE_UNIT {
            row += 1
            dy = 0
            if row >= BG_HEIGHT {  // warp tunnel
                row = 0
            }
        }
    }

    private func decrementVertical(value: Int = 1) {
        dy -= value
        if dy <= -MAZE_UNIT {
            row -= 1
            dy = 0
            if row < 0 {  // warp tunnel
                row = BG_HEIGHT-1
            }
        }
    }

    func isCenter()->Bool {
        return (dx == 0) && (dy == 0)
    }

    func canMove(direction: EnDirection)->Bool {
        return ( (direction == .Left || direction == .Right) && (dy == 0) ||
                 (direction ==   .Up || direction ==  .Down) && (dx == 0) )
    }
}

/// Base class for characters moving in the maze.
class CgActor: CbContainer {

    enum EnActor: Int {
        case None = -2
        case Pacman = -1
        case Blinky = 0
        case Pinky = 1
        case Inky = 2
        case Clyde = 3
        case SpecialTarget = 4
        case Pts = 5
        case TargetBlinky = 10
        case TargetPinky = 11
        case TargetInky = 12
        case TargetClyde = 13
        case TargetPacman = 14

        func getSpriteNumber() -> Int {
            switch self {
                case .None: return 0
                case .Pacman: return 9
                case .Blinky: return 13
                case .Pinky: return 14
                case .Inky: return 15
                case .Clyde: return 16
                case .TargetBlinky: return 20
                case .TargetPinky: return 21
                case .TargetInky: return 22
                case .TargetClyde: return 23
                case .TargetPacman: return 24
                case .SpecialTarget: return 31
                case .Pts: return 32 // 32..41(2x5)
            }
        }

        func getDepth() -> CGFloat {
            switch self {
                case .None: return 0
                case .Pacman: return 10
                case .Blinky: return 23
                case .Pinky: return 22
                case .Inky: return 21
                case .Clyde: return 20
                case .SpecialTarget: return 1
                case .Pts: return 0
                case .TargetBlinky: return 33
                case .TargetPinky: return 32
                case .TargetInky: return 31
                case .TargetClyde: return 30
                case .TargetPacman: return 34
            }
        }

        func getTarget() -> EnActor {
            switch self {
                case .Blinky: return .TargetBlinky
                case .Pinky: return .TargetPinky
                case .Inky: return .TargetInky
                case .Clyde: return .TargetClyde
                case .Pacman: return .TargetPacman
                default: return .None
            }
        }

    }

    var sprite: CgSpriteManager!
    var deligateActor: ActorDeligate!

    var position: CgPosition = CgPosition()
    var direction: CgDirection = CgDirection()
    
    var actor: EnActor = .None
    var sprite_number: Int = 0
    
    init(binding object: CgSceneFrame, deligateActor: ActorDeligate) {
        super.init(binding: object)
        self.sprite = object.sprite
        self.deligateActor = deligateActor
        enabled = false
    }

    // ============================================================
    //   Core operation methods for actor
    //  - Sequence: reset()->start()->update() called->stop()
    // ============================================================
    
    /// Reset
    ///  Event messages are not sent.
    func reset() {
        enabled = false
        position.set(column: 0, row: 0)
        direction.reset()
        sprite.setDepth(sprite_number, zPosition: actor.getDepth())
    }
    
    /// Start
    ///  Event messages are sent.
    func start() {
        enabled = true
    }
    
    /// Stop
    ///  Event messages are not sent.
    func stop() {
        enabled = false
    }

}
