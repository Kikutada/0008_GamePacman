//
//  GameGhost.swift
//  0005_EnemyTest
//
//  Created by Kikutada on 2020/08/24.
//  Copyright © 2020 Kikutada All rights reserved.
//

import Foundation
import UIKit

//=================================================================
// Ghost class
//=================================================================

/// Ghost Blinky class
class CgGhostBlinky : CgGhost {

    override init(binding object: CgSceneFrame, deligateActor: ActorDeligate) {
        super.init(binding: object, deligateActor: deligateActor)
        actor = .Blinky
        sprite_number = actor.getSpriteNumber()
    }
    
    // ============================================================
    //   Core operation methods for actor
    //  - Sequence: reset()->start()->update() called->stop()
    // ============================================================

    /// Reset ghost state and draw at default position
    override func reset() {
        super.reset()
        position.set(column: 13, row: 21, dx: 4)
        updateDirection(to: .Left)
        state.set(to: .Scatter)
        draw()
    }

    // ============================================================
    //  State Machine methods
    // ============================================================

    /// Chase player to enter chase state.
    /// Always chase the Pacman during the chase mode.
    /// - Parameter playerPosition: Player's position
    func chase(playerPosition: CgPosition) {
        super.setStateToChase(targetPosition: playerPosition)
    }
    
    /// Set the target position in scatter state.
    /// Blinky moves around the upper right in the play field.
    override func entryActionToScatter() {
        target.set(column: 25, row: 35)
        super.entryActionToScatter()
    }

    /// Set return destination in nest from escape state.
    override func entryActionToEscapeInNest() {
        target.set(column: 13, row: 18, dx: 4, dy: -4)
    }

}

/// Ghost Pinky class
class CgGhostPinky : CgGhost {
    
    override init(binding object: CgSceneFrame, deligateActor: ActorDeligate) {
        super.init(binding: object, deligateActor: deligateActor)
        actor = .Pinky
        sprite_number = actor.getSpriteNumber()
    }

    // ============================================================
    //   Core operation methods for actor
    //  - Sequence: reset()->start()->update() called->stop()
    // ============================================================

    /// Reset ghost state and draw at default position
    override func reset() {
        super.reset()
        position.set(column: 13, row: 18, dx: 4)
        updateDirection(to: .Down)
        state.set(to: .Standby)
        draw()
    }

    // ============================================================
    //  State Machine methods
    // ============================================================

    /// Chase player to enter chase state.
    /// Aiming for Pacman's third destination (From the mouth)
    /// - Parameters:
    ///   - playerPosition: Player's position
    ///   - playerDirection: Player's direction
    func chase(playerPosition: CgPosition, playerDirection: EnDirection) {
        let dx = playerDirection.getHorizaontalDelta()*4
        let dy = playerDirection.getVerticalDelta()*4
        let newTargetPosition = CgPosition(column: playerPosition.column+dx, row: playerPosition.row+dy)
        super.setStateToChase(targetPosition: newTargetPosition)
    }
    
    /// Set the direction in standby state.
    override func entryActionToStandby() {
        updateDirection(to: .Down)
    }

    /// Set the target position in scatter state.
    /// Pinky moves around the upper left on the play field.
    override func entryActionToScatter() {
        target.set(column: 2, row: 35)
        super.entryActionToScatter()
    }
    
    /// Set return destination in nest from escape state.
    override func entryActionToEscapeInNest() {
        target.set(column: 13, row: 18, dx: 4, dy: -4)
    }

}

/// Ghost Inky class
class CgGhostInky : CgGhost {
    
    override init(binding object: CgSceneFrame, deligateActor: ActorDeligate) {
        super.init(binding: object, deligateActor: deligateActor)
        actor = .Inky
        sprite_number = actor.getSpriteNumber()
    }

    // ============================================================
    //   Core operation methods for actor
    //  - Sequence: reset()->start()->update() called->stop()
    // ============================================================

    /// Reset ghost state and draw at default position
    override func reset() {
        super.reset()
        position.set(column: 11, row: 18, dx: 4)
        updateDirection(to: .Up)
        state.set(to: .Standby)
        draw()
    }

    // ============================================================
    //  State Machine methods
    // ============================================================

    /// Chase player to enter chase state.
    /// Aiming for a point-symmetrical mass centered on Blinky and Pacman.
    /// - Parameters:
    ///   - playerPosition: Player's position
    ///   - blinkyPosition: Blinky's position
    func chase(playerPosition: CgPosition, blinkyPosition: CgPosition) {
        let dx = playerPosition.column - blinkyPosition.column
        let dy = playerPosition.row - blinkyPosition.row
        let newTargetPosition = CgPosition(column: playerPosition.column+dx, row: playerPosition.row+dy)
        super.setStateToChase(targetPosition: newTargetPosition)
    }

    /// Set the target position in scatter state.
    /// Inky moves around the lower right on the play field.
    override func entryActionToScatter() {
        target.set(column: 27, row: 0)
        super.entryActionToScatter()
    }
    
    /// Set return destination in nest from escape state.
    override func entryActionToEscapeInNest() {
        target.set(column: 11, row: 18, dx: 4, dy: -4)
    }

}

/// Ghost Clyde class
class CgGhostClyde : CgGhost {
    
    private var chaseMode = false
    
    override init(binding object: CgSceneFrame, deligateActor: ActorDeligate) {
        super.init(binding: object, deligateActor: deligateActor)
        actor = .Clyde
        sprite_number = actor.getSpriteNumber()
    }

    // ============================================================
    //   Core operation methods for actor
    //  - Sequence: reset()->start()->update() called->stop()
    // ============================================================

    /// Reset ghost state and draw at default position
    override func reset() {
        super.reset()
        chaseMode = false
        position.set(column: 15, row: 18, dx: 4)
        updateDirection(to: .Up)
        state.set(to: .Standby)
        draw()
    }

    // ============================================================
    //  State Machine methods
    // ============================================================

    /// Chase player to enter chase state.
    /// If Clyde is outside the radius of 130 dots from Pacman, it has the character of a Blinky,
    /// otherwise Clyde moves by random within the radius regardless of Pacman.
    func chase(playerPosition: CgPosition) {
        let dx = playerPosition.x - position.x
        let dy = playerPosition.y - position.y
        if (dx*dx+dy*dy) > 130*130 {
            chaseMode = true
        } else {
            chaseMode = false
        }
        super.setStateToChase(targetPosition: playerPosition)
    }
    
    /// Set the target position in scatter state.
    /// Clyde moves around the lower left on the play field.
    override func entryActionToScatter() {
        target.set(column: 0, row: 0)
        super.entryActionToScatter()
    }

    /// Set return destination in nest from escape state.
    override func entryActionToEscapeInNest() {
        target.set(column: 13+2, row: 18, dx: 4, dy: -4)
    }

    /// Clyde switches scatter and random movement in chase mode.
    override func doActionInChase() {
        if chaseMode {
            super.doActionInChase()
        } else {
            // Clyde moves by ranodm.
            let speed = getGhostSpeed(action: .Walking)
            move(targetSelected: false, speed: speed, oneWayProhibition: true)
        }
    }
    
    // ============================================================
    //  General methods in this class
    // ============================================================

    /// Draw at target position
    ///  Target position isn't shown while Cyde is moving randomly.
    /// - Parameter show: True is to draw.
    override func drawTargetPosition(show: Bool) {
        let _show = state.get() == .Chase ? chaseMode && show : show
        super.drawTargetPosition(show: _show)
    }
}

/// Ghost Manager class
class CgGhostManager {
    
    private var allGhosts: [CgGhost] = []
    var collisionPosition = CgPosition()
    
    func append(_ ghost: CgGhost) {
        allGhosts.append(ghost)
    }

    func reset() {
        for ghost in allGhosts {
            ghost.reset()
        }
    }

    func start() {
        for ghost in allGhosts {
            ghost.start()
        }
    }

    func stop() {
        for ghost in allGhosts {
            ghost.stop()
        }
    }

    func draw() {
        for ghost in allGhosts {
            ghost.draw()
        }
    }

    func clear() {
        for ghost in allGhosts {
            ghost.clear()
        }
        drawTargetPosition(show: false)
    }

    func setStateToFrightened(time: Int) {
        for ghost in allGhosts {
            ghost.setStateToFrightened(time: time)
        }
    }

    func setStateToGoOut(numberOfGhosts: Int, forcedOneGhost: Bool) {
        var count: Int = 0
        for ghost in allGhosts {
            if ghost.state.get() == .Standby {
                ghost.setStateToGoOut()
                if forcedOneGhost { break }
            }
            count += 1
            if numberOfGhosts == count { break }
        }
    }
    
    func isFrightenedState() -> Bool {
        var frightenedState: Bool = false
        for ghost in allGhosts {
            if ghost.state.isFrightened() {
                frightenedState = true
                break
            }
        }
        return frightenedState
    }

    func isEscapeState() -> Bool {
        var escapeState: Bool = false
        for ghost in allGhosts {
            if ghost.state.get() == .Escape || ghost.state.getNext() == .Escape {
                escapeState = true
                break
            }
        }
        return escapeState
    }
    
    enum EnCollisionResult {
        case None, PlayerEatsGhost, PlayerMiss
    }
    
    func detectCollision(playerPosition: CgPosition) -> EnCollisionResult {
        var collisionResult: EnCollisionResult = .None

        for ghost in allGhosts {
            if (abs(ghost.position.x-playerPosition.x) <= 4) && (abs(ghost.position.y-playerPosition.y) <= 4) {
                if ghost.state.isFrightened()  {
                    ghost.setStateToEscape()                    
                    ghost.clear()
                    collisionPosition = ghost.position
                    collisionResult = .PlayerEatsGhost
                } else if !ghost.state.isEscaping()  {
                    collisionResult = .PlayerMiss
                }
                break
            }
        }

        return collisionResult
    }

    func startWithoutEscaping() {
        for ghost in allGhosts {
            if !ghost.state.isEscaping() {
                ghost.start()
            }
        }
    }

    func stopWithoutEscaping() {
        for ghost in allGhosts {
            if !ghost.state.isEscaping() {
                ghost.stop()
            }
        }
    }

    func isGhostInNest() -> Bool {
        var monstersInNest: Bool = false
        for ghost in allGhosts {
            if ghost.state.get() == .Standby {
                monstersInNest = true
                break
            }
        }
        return monstersInNest
    }

    func drawTargetPosition(show: Bool) {
        for ghost in allGhosts {
            ghost.drawTargetPosition(show: show)
        }
    }
    
}

//=================================================================
// Common class for ghosts
//=================================================================

/// State of ghosts class
class CgGhostState : CbContainer {

    enum EnGhostState {
        case Init, Standby, GoOut, Scatter, Chase, Escape, EscapeInNest
    }

    private var currentState: EnGhostState = .Init
    private var nextState: EnGhostState = .Init

    private var frightenedState: Bool = false
    private var frightenedBlinkingState: Bool = false
    private var timer_frightenedState: CbTimer!
    private var timer_frightenedStateWhileBlinking: CbTimer!
    private var frightenedBlinkingOn: Bool = false

    private var spurtState: Bool = false
    private var updateDrawing: Bool = false
    
    override init(binding object: CbObject) {
        super.init(binding: object)
        timer_frightenedState = CbTimer(binding: self)
        timer_frightenedStateWhileBlinking = CbTimer(binding: self)
    }

    override func update(interval: Int) {
        if frightenedState {
            updateFrightenedState()
        }
    }

    private func updateFrightenedState() {
        if !frightenedBlinkingState {
            if timer_frightenedState.get() <= 2000 { // ms
                timer_frightenedStateWhileBlinking.set(interval: 20*16)  // ms
                timer_frightenedStateWhileBlinking.start()
                frightenedBlinkingState = true
            }
        } else {
            if timer_frightenedStateWhileBlinking.get() == 20*16 { // ms
                frightenedBlinkingOn = true
                updateDrawing = true
            } else if timer_frightenedStateWhileBlinking.get() == 10*16 { // ms
                frightenedBlinkingOn = false
                updateDrawing = true
            }
            if timer_frightenedStateWhileBlinking.isEventFired() {
                timer_frightenedStateWhileBlinking.set(interval: 21*16)  // ms
                timer_frightenedStateWhileBlinking.start()
            }
        }
        if timer_frightenedState.isEventFired() {
            setFrightened(false)
        }
    }

    func reset() {
        currentState = .Init
        nextState = .Init
        frightenedState = false
        frightenedBlinkingState = false
        frightenedBlinkingOn = false
        spurtState = false
        timer_frightenedState.reset()
        timer_frightenedStateWhileBlinking.reset()
        updateDrawing = false
    }

    func get() -> EnGhostState {
        return currentState
    }

    func getNext() -> EnGhostState {
        return nextState
    }

    func set(to state: EnGhostState) {
        nextState = state
    }

    func update() {
        if currentState != nextState {
            currentState = nextState
            updateDrawing = true
        }
    }

    func isChanging() -> Bool {
        return currentState != nextState
    }
    
    func setSpurt(_ spurt: Bool) {
        if spurt != spurtState {
            spurtState = spurt
            updateDrawing = true
        }
    }
    
    func isSpurt() -> Bool {
        return spurtState
    }

    func setFrightened(_ on: Bool, interval time: Int = 0) {
        frightenedState = on
        frightenedBlinkingState = false
        updateDrawing = true
        if on {
            timer_frightenedState.set(interval: time)
            timer_frightenedState.start()
        } else {
            timer_frightenedState.reset()
        }
    }
    
    func isFinishFrightened() -> Bool {
        return timer_frightenedState.isEventFired()
    }

    func isFrightenedBlinkingState() -> Bool {
        return frightenedBlinkingState
    }
    
    func isFrightenedBlinkingOn() -> Bool {
        return timer_frightenedStateWhileBlinking.get() > 10*16 // ms
    }

    func isFrightened() -> Bool {
        return frightenedState && !isEscaping()
    }

    func isEscaping() -> Bool {
        return currentState == .Escape || nextState == .Escape || currentState == .EscapeInNest || nextState == .EscapeInNest
    }

    func isDrawingUpdated() -> Bool {
        return updateDrawing
    }
    
    func clearDrawingUpdate() {
        updateDrawing = false
    }
}

/// Based ghost actor class
class CgGhost : CgActor {

    enum EnGhostAction {
        case None, Walking, Spurting, Frightened, Warping, Standby, GoingOut, Escaping
    }

    enum EnMovementRestrictions {
        case None, OnlyVertical
    }

    var target: CgPosition = CgPosition()
    var state: CgGhostState!

    private var movementRestriction: EnMovementRestrictions = .None

    override init(binding object: CgSceneFrame, deligateActor: ActorDeligate) {
        super.init(binding: object, deligateActor: deligateActor)
        state = CgGhostState(binding: self)
        enabled = false
    }

    // ============================================================
    //   Core operation methods for actor
    //  - Sequence: reset()->start()->update() called->stop()
    // ============================================================

    /// Reset ghost states and draw at default position
    override func reset() {
        super.reset()
        direction.reset()
        state.reset()
        movementRestriction = .None
    }

    /// Start
    override func start() {
        super.start()
        draw()
    }
    
    /// Stop
    override func stop() {
        super.stop()
    }
    
    /// Update handler
    /// - Parameter interval: Interval time(ms) to update
    override func update(interval: Int) {
        
        //
        // Entry Action to state
        //
        if state.isChanging() {
            switch state.getNext() {
                case .Init : break
                case .Standby: entryActionToStandby()
                case .GoOut: entryActionToGoOut()
                case .Scatter: entryActionToScatter()
                case .Chase: entryActionToChase()
                case .Escape: entryActionToEscape()
                case .EscapeInNest: entryActionToEscapeInNest()
            }
            state.update()
        }

        //　REMARK: When Ghost returns to the nest, it will stop while Pacman eats the ghost.
        if state.getNext() == .Standby && deligateActor.isSuspendUpdating() {
            self.enabled = false
            return
        }

        //
        // Do Action in state
        //
        switch state.get() {
            case .Init : break
            case .Standby: doActionInStandby()
            case .GoOut:  doActionInGoOut()
            case .Scatter:
                if state.isFrightened() {
                    doActionInFrightened()
                } else {
                    doActionInScatter()
                }
            case .Chase:
                if state.isFrightened() {
                    doActionInFrightened()
                } else {
                    doActionInChase()
                }
            case .Escape:  doActionInEscape()
            case .EscapeInNest:  doActionInEscapeInNest()
        }

        //  Update direction and sprite animation for changes.
        if state.isChanging() || direction.isChanging() || state.isDrawingUpdated() {
            if direction.isChanging() {
                position.roundDown()
                direction.update()
            }
            draw()
            state.clearDrawingUpdate()
        }

        // Update position.
        sprite.setPosition(sprite_number, x: position.x, y: position.y)
    }
    
    // ============================================================
    //  Entry action to enter each state.
    // ============================================================
    func entryActionToStandby() {
        updateDirection(to: .Up)
    }

    func entryActionToGoOut() {
        // Ghost moves out of the nest.
        target.set(column: 13, row: 21, dx: 4)
        movementRestriction = (position.dy != 0 && movementRestriction == .None) ? .OnlyVertical : .None
    }

    func entryActionToScatter() {
        switch state.get() {
            case .Init:
                break
            case .Chase:
                updateDirection(to: direction.get().getReverse())
            case .GoOut:
                var nextDirection = getTargetDirection(selected: .Horizontal)
                if nextDirection == .Stop { nextDirection = .Left }
                updateDirection(to: nextDirection)
        default:
                break
        }
    }

    func entryActionToChase() {
        switch state.get() {
            case .Scatter:
                updateDirection(to: direction.get().getReverse())
            default:
                break
        }
    }
    
    func entryActionToEscape() {
        target.set(column: 13, row: 21, dx: 4)
        sprite.stopAnimation(sprite_number)
    }

    func entryActionToEscapeInNest() {
        // pure virtual
    }

    // ============================================================
    //  Do activities in state.
    // ============================================================
    /// Ghost moves up and down in the nest.
    func doActionInStandby() {
        var speed = getGhostSpeed(action: .Standby)
        let currentDirectrion = direction.get()

        while(speed > 0) {
            if (currentDirectrion == .Up && position.dy != HALF_MAZE_UNIT) || (currentDirectrion == .Down && position.dy != -HALF_MAZE_UNIT) {
                speed = position.move(to: currentDirectrion, speed: speed)
            } else {
                direction.set(to: currentDirectrion.getReverse())
                break
            }
        }

    }

    func doActionInGoOut() {
        // Ghost moves only vertically and waits until it is in the middle position.
        if movementRestriction == .OnlyVertical {
            doActionInStandby()
            if position.dy == 0 {
                movementRestriction = .None
            }
            return
        }

        // Ghost moves out of the nest.
        var speed = getGhostSpeed(action: .GoingOut)

        while(speed > 0) {
            let horizontalDirection = getTargetDirection(selected: .Horizontal)
            let currentDirectrion = horizontalDirection != .Stop ? horizontalDirection : getTargetDirection(selected: .Vertiacal)
            
            if currentDirectrion != .Stop {
                if currentDirectrion == direction.get() {
                    speed = position.move(to: direction.get(), speed: speed)
                } else {
                    direction.set(to: currentDirectrion)
                    break
                }
            } else {
                state.set(to: .Scatter)
                break
            }
        }
    }

    func doActionInEscapeInNest() {
        // Ghost moves out of the nest.
        var speed = getGhostSpeed(action: .Escaping)

        while(speed > 0) {
            let verticalDirection = getTargetDirection(selected: .Vertiacal)
            let currentDirectrion = verticalDirection != .Stop ? verticalDirection : getTargetDirection(selected: .Horizontal)
            
            if currentDirectrion != .Stop {
                if currentDirectrion == direction.get() {
                    speed = position.move(to: direction.get(), speed: speed)
                } else {
                    direction.set(to: currentDirectrion)
                    break
                }
            } else {
                state.setFrightened(false)
                state.set(to: .Standby)
                break
            }
        }
    }
    
    func doActionInScatter() {
        let speed = getGhostSpeed(action: .Walking)
        move(targetSelected: true, speed: speed, oneWayProhibition: true)
    }

    func doActionInChase() {
        doActionInScatter()
    }

    func doActionInEscape() {
        if getTargetDirection() == .Stop {
            state.set(to: .EscapeInNest)
        } else {
            let speed = getGhostSpeed(action: .Escaping)
            move(targetSelected: true, speed: speed, oneWayProhibition: false)
        }
    }
    
    func doActionInFrightened() {
        let speed = getGhostSpeed(action: .Frightened)
        move(targetSelected: false, speed: speed, oneWayProhibition: false)
    }

    // ============================================================
    //  Change state methods
    // ============================================================
    func setStateToStandby() {
        guard state.get() == .EscapeInNest else { return }
        state.set(to: .Standby)
    }

    func setStateToGoOut() {
        guard state.get() == .Standby else { return }
        state.set(to: .GoOut)
    }
    
    func setStateToChase(targetPosition: CgPosition) {
        guard (state.get() == .Scatter || state.get() == .Chase) && !state.isFrightened() else { return }
        state.set(to: .Chase)
        target.set(column: targetPosition.column, row: targetPosition.row)
    }

    func setStateToScatter() {
        guard state.get() == .Chase else { return }
        state.set(to: .Scatter)
    }
    
    // While ghost is escaping to the nest, it doesn't change if eating more power food.
    func setStateToFrightened(time: Int) {
        guard !state.isEscaping() else { return }
        state.setFrightened(true, interval: time)
        updateDirection(to: direction.get().getReverse())
    }
    
    func setStateToEscape() {
        guard state.isFrightened() else { return }
        state.set(to: .Escape)
    }

    // ============================================================
    //  General methods
    // ============================================================
    func getGhostSpeed(action: EnGhostAction) -> Int {
        var _action: EnGhostAction = action
        let road = deligateActor.getTileAttribute(to: .Stop, position: position)

        switch action {
            case .Walking:
                if road == .Slow {
                    _action = .Warping
                } else if state.isSpurt() {
                    _action = .Spurting
                }
            case .Frightened:
                if road == .Slow {
                    _action = .Warping
                }
            default:
                // Standby, GoingOut, Escaping
                break
        }
        
        return deligateActor.getGhostSpeed(action: _action)
    }

    func updateDirection(to nextDirection: EnDirection) {
        if direction.get() != nextDirection {
            direction.set(to: nextDirection)
            direction.update()
            position.roundDown(to: .Stop)
            position.amountMoved = 1
        }
    }

    func canMove(direction: EnDirection, oneWayProhibition: Bool = true) -> Bool {
        var can = true
        if position.canMove(direction: direction) {
            let road = deligateActor.getTileAttribute(to: direction, position: position)
            
            if (road == .Wall) {
                can = false
            } else if oneWayProhibition && (road == .Oneway && direction == .Up && position.isCenter()) {
                can = false
            }
        } else {
            can = false
        }
        return can
    }

    enum EnTargetDirection {
        case All, Horizontal, Vertiacal
    }

    func getTargetDirection(selected: EnTargetDirection = .All) -> EnDirection {
        var direction: EnDirection = .Stop
        let delta_x = target.x - position.x
        let delta_y = target.y - position.y
        
        switch selected {
            case .All:
                if delta_x != 0 || delta_y != 0 {
                    if abs(delta_x) > abs(delta_y) {
                        direction = delta_x > 0 ? .Right : .Left
                    } else {
                        direction = delta_y > 0 ? .Up : .Down
                    }
                }

            case .Horizontal:
                if delta_x < 0 {
                    direction = .Left
                } else if delta_x > 0 {
                    direction = .Right
                }

            case .Vertiacal:
                if delta_y < 0 {
                    direction = .Down
                } else if delta_y > 0 {
                    direction = .Up
                }
        }
        
        return direction
    }
    
    /// Ghost moves to target position or random position by speed amount.
    /// - Parameters:
    ///   - targetSelected: True is that ghost moves to target position. False is that ghost moves by random
    ///   - speed: Speed amount
    ///   - oneWayProhibition: True prohibits that ghost move through one way.
    func move(targetSelected: Bool, speed: Int, oneWayProhibition: Bool) {
        var _speed = speed
        var nextDirection = direction.get()

        // REMARK: Without this code, ghost will quickly change directions.
        //         After the ghost changes direction,
        //         move one dot or more and then change the next direction.
        if position.amountMoved > 0 {
            if targetSelected {
                nextDirection = decideDirectionByTarget(oneWayProhibition: oneWayProhibition)
            } else {
                nextDirection = decideDirectionByRandom(oneWayProhibition: oneWayProhibition)
            }
            direction.set(to: nextDirection)
            if direction.isChanging() {
                position.roundDown(to: .Stop)
                position.amountMoved = 0
            }
        }
        
        // Move every 1dot at a time until speed becomes 0.
        while(_speed > 0) {
            if canMove(direction: nextDirection, oneWayProhibition: oneWayProhibition) {
                _speed = position.move(to: nextDirection, speed: _speed)
            } else {
                position.roundDown(to: .Stop)
                break
            }
        }
    }
    
    /// Ghost decides the next direction to chase target position.
    /// - Parameters:
    ///   - oneWayProhibition: True prohibits that ghost move through one way.
    ///   - forcedDirectionChange: True changes the direction the ghost is moving
    /// - Returns: Next direction to move
    private func decideDirectionByTarget(oneWayProhibition: Bool, forcedDirectionChange: Bool = false) -> EnDirection {
        let currentDirection = direction.get()
        var nextDirection: EnDirection  = .None

        if position.isCenter() || forcedDirectionChange {
            let allDirections: [EnDirection] = [.Up, .Down, .Left, .Right]
            var minDistance = MAZE_MAX_DISTANCE

            for _direction in allDirections {
                if _direction != currentDirection.getReverse() || forcedDirectionChange {
                    if canMove(direction: _direction, oneWayProhibition: oneWayProhibition) {
                        let deltaColumn = position.column + _direction.getHorizaontalDelta() - target.column
                        let deltaRow = position.row + _direction.getVerticalDelta() - target.row
                        let distance = deltaColumn * deltaColumn + deltaRow * deltaRow
                        if distance < minDistance {
                            minDistance = distance
                            nextDirection = _direction
                        }
                    }
                }
            }
           
            if nextDirection == .None {
                nextDirection = currentDirection.getReverse()
            }
        } else {
            nextDirection = currentDirection
        }

        return nextDirection
    }

    /// Ghost decides the next direction by random.
    /// - Parameters:
    ///   - oneWayProhibition: True prohibits that ghost move through one way.
    ///   - forcedDirectionChange: True changes the direction the ghost is moving
    /// - Returns: Next direction to move
    private func decideDirectionByRandom(oneWayProhibition: Bool, forcedDirectionChange: Bool = false) -> EnDirection {
        let currentDirection = direction.get()
        var nextDirection = currentDirection

        if position.isCenter() || forcedDirectionChange {
            nextDirection = direction.get().getRandom()

            for _ in 1 ..< 3 {
                repeat {
                    nextDirection = nextDirection.getClockwise()
                } while !canMove(direction: nextDirection, oneWayProhibition: oneWayProhibition)

                if nextDirection != currentDirection.getReverse() {
                    break
                }
            }
        }
           
        return nextDirection
    }

    // ============================================================
    //  Draw and clear sprite methods.
    // ============================================================
    func draw() {
        if enabled == false {
            // Stopped ghost
            sprite.stopAnimation(sprite_number)
            if !state.isFrightened() {
                let texture1 = actor.rawValue*16+direction.get().rawValue*2+64
                sprite.draw(sprite_number, x: position.x, y: position.y, texture: texture1)
            }

        } else if state.isFrightened() {
            // Frightened ghost
            if !state.isFrightenedBlinkingState()  {
                sprite.startAnimation(sprite_number, sequence: [72,73], timePerFrame: 0.1, repeat: true)
            } else {
                if state.isFrightenedBlinkingOn() {
                    sprite.startAnimation(sprite_number, sequence: [74,75], timePerFrame: 0.1, repeat: true)
                } else {
                    sprite.startAnimation(sprite_number, sequence: [72,73], timePerFrame: 0.1, repeat: true)
                }
            }

        } else if state.isEscaping() {
            // Escaping ghost
            let texture1 = direction.get().rawValue+88
            sprite.draw(sprite_number, x: position.x, y: position.y, texture: texture1)

        } else {
            // Walking ghost
            let spurt = state.isSpurt() && deligateActor.isDebugMode() ? 16*9 : 0  // For debug
            let texture1 = actor.rawValue*16+direction.get().rawValue*2+64+spurt
            let texture2 = texture1 + 1
            sprite.startAnimation(sprite_number, sequence: [texture1,texture2], timePerFrame: 0.12, repeat: true)
        }
    }

    func clear() {
        sprite.stopAnimation(sprite_number)
        sprite.clear(sprite_number)
    }

    /// Draw at target position
    /// - Parameter show: True is to draw.
    func drawTargetPosition(show: Bool) {
        let targetActor: EnActor = actor.getTarget()
        let spriteNumber = targetActor.getSpriteNumber()
        let _state = show ? state.get() : .Init

        switch _state {
            case .GoOut: fallthrough
            case .Scatter: fallthrough
            case .Escape: fallthrough
            case .Chase:
                if state.isFrightened() {
                    sprite.clear(spriteNumber)
                } else {
                    sprite.draw(spriteNumber, x: target.x, y: target.y, texture: 79+actor.rawValue*16)
                    sprite.setDepth(spriteNumber, zPosition: targetActor.getDepth())
                }
            default:
                sprite.clear(spriteNumber)
        }
    }

}
