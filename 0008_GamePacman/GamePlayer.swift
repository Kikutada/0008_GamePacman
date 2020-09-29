//
//  GamePlayer.swift
//  0004_PlayerTest
//
//  Created by Kikutada on 2020/08/17.
//  Copyright © 2020 Kikutada All rights reserved.
//

import Foundation
import UIKit

/// Player(Pacman) class derived from CgAcotr
class CgPlayer : CgActor {

    enum EnPlayerAction {
        case None, Stopping, Walking, Turning, EatingFeed, EatingPower, EatingFruit
    }

    var targetDirecition: EnDirection = .Stop
    var actionState: EnPlayerAction = .None

    var timer_playerWithPower: CbTimer!
    var timer_playerNotToEat: CbTimer!
 
    private var touchOperationEnabled : Bool = false
    private var targetPosition: CgPosition = .init()

    override init(binding object: CgSceneFrame, deligateActor: ActorDeligate) {
        super.init(binding: object, deligateActor: deligateActor)
        timer_playerWithPower = CbTimer(binding: self)
        timer_playerNotToEat = CbTimer(binding: self)
        actor = .Pacman
        sprite_number = actor.getSpriteNumber()
    }

    // ============================================================
    //  Event Handler
    // ============================================================

    /// Event handler
    /// - Parameters:
    ///   - sender: Message sender
    ///   - id: Message ID
    ///   - values: Parameters of message
    override func handleEvent(sender: CbObject, message: EnMessage, parameter values: [Int]) {
        switch message {
            case .Swipe where deligateActor.isOperationMode(mode: CgContext.EnOperationMode.Swipe):
                if let direction = EnDirection(rawValue: values[0]) {
                    targetDirecition = direction
                }

            case .Touch where deligateActor.isOperationMode(mode: CgContext.EnOperationMode.Touch):
                setTargetPosition(x: values[0], y: values[1])
                targetDirecition = decideDirectionByTarget(forcedDirectionChange: true)
                
            default:
                break
        }
    }

    // ============================================================
    //   Core operation methods for actor
    //  - Sequence: reset()->start()->update() called->stop()
    // ============================================================

    /// Reset player states and draw at default position
    override func reset() {
        super.reset()
        timer_playerWithPower.reset()
        timer_playerNotToEat.reset()
        timer_playerWithPower.set(interval: deligateActor.getTimeOfPlayerWithPower())
        timer_playerNotToEat.set(interval: deligateActor.getTimeOfPlayerNotToEat())

        targetDirecition = .Stop
        actionState = .None

        position.set(column: 13, row: 9, dx: 4)
        direction.set(to: .Stop)
        draw(to: .None)
    }

    /// Start
    override func start() {
        super.start()
        timer_playerNotToEat.start()
        draw(to: direction.get())
    }

    /// Stop
    override func stop() {
        super.stop()
    }
    
    /// Update handler
    /// - Parameter interval: Interval time(ms) to update
    override func update(interval: Int) {
        if deligateActor.isOperationMode(mode: CgContext.EnOperationMode.Touch) {
            targetDirecition = decideDirectionByTarget()
        }

        if actionState == .Turning {
            turn()
        } else {
            if canMove(to: targetDirecition) {
                direction.set(to: targetDirecition)
            } else {
                direction.update()
                if canTurn() {
                    actionState = .Turning
                    direction.set(to: targetDirecition)
                    return
                }
            }
            move()
        }
    }

    // ============================================================
    //  General methods in this class
    // ============================================================

    ///
    /// Can player turn the corner?
    ///
    func canTurn() -> Bool {
        if direction.get().getClockwise() == targetDirecition || direction.get().getCounterClockwise() == targetDirecition {
            let deltaDistance: Int = position.getAbsoluteDelta(to: direction.get())

            if deltaDistance >= 6 {
                let targetColumn = position.column + direction.get().getHorizaontalDelta() + targetDirecition.getHorizaontalDelta()
                let targetRow    = position.row + direction.get().getVerticalDelta() + targetDirecition.getVerticalDelta()
                let value = deligateActor.getTile(column: targetColumn, row: targetRow)

                if canMove(through: value) {
                    return true
                }
            }
        }
        return false
     }

    ///
    ///　Turn inwards
    ///
    func turn() {
        let power: Bool = timer_playerWithPower.isCounting()
        var speedForCurrentDirection = deligateActor.getPlayerSpeed(action: .Walking, with: power)
        var speedForNextDirection = speedForCurrentDirection

        // Move every 1dot at a time until speed becomes 0.
        while(speedForCurrentDirection > 0) {
            if position.getAbsoluteDelta(to: direction.get()) > 0 {
                // Move diagonally
                speedForCurrentDirection = position.move(to: direction.get(), speed: speedForCurrentDirection)
                speedForNextDirection = position.move(to: direction.getNext(), speed: speedForNextDirection)
            } else {
                actionState = .None
                position.roundDown(to: direction.get())
                direction.update()
                break
            }
        }
        
        sprite.setPosition(sprite_number, x: position.x, y: position.y)
        draw(to: direction.getNext())
    }
    
    /// Can player move through the tile?
    /// - Parameter tile: Tile
    /// - Returns: True if player can move
    func canMove(through tile: EnMazeTile) -> Bool {
        return tile != .Wall
    }
    
    /// Can player move in the direction?
    /// - Parameter nextDirection: Direction
    /// - Returns: True if player can move
    func canMove(to nextDirection: EnDirection) -> Bool {
        if position.canMove(to: nextDirection) {
            let value: EnMazeTile = deligateActor.getTileAttribute(to: nextDirection, position: position)
            return canMove(through: value)
        }
        return false
    }

    ///
    ///  Move and eat feed or fruit or nothing
    ///
    func move() {
        let power: Bool = timer_playerWithPower.isCounting()
        var speed: Int = 0
        let deltaDistance: Int = position.getAbsoluteDelta(to: direction.getNext())
        let targetColumn = position.column + direction.getNext().getHorizaontalDelta()
        let targetRow = position.row + direction.getNext().getVerticalDelta()
        let tile: EnMazeTile = (deltaDistance < 4) ? .Road : deligateActor.getTile(column: targetColumn, row: targetRow)

        switch tile {
            case .Feed:
                speed = deligateActor.getPlayerSpeed(action: .EatingFeed, with: power)
                deligateActor.playerEatFeed(column: targetColumn, row: targetRow, power: false)
                timer_playerNotToEat.restart()

            case .PowerFeed:
                speed = deligateActor.getPlayerSpeed(action: .EatingPower, with: power)
                deligateActor.playerEatFeed(column: targetColumn, row: targetRow, power: true)
                timer_playerNotToEat.restart()
                timer_playerWithPower.restart()

            case .Fruit:
                speed = deligateActor.getPlayerSpeed(action: .EatingFruit, with: power)
                deligateActor.playerEatFruit(column: targetColumn, row: targetRow)

            default:
                speed = deligateActor.getPlayerSpeed(action: .Walking, with: power)
        }

        //
        // Move every 1dot at a time until speed becomes 0.
        //
        while(speed > 0) {
            // Can player move in the next direction?
            if canMove(to: direction.getNext()) {
                speed = position.move(to: direction.getNext(), speed: speed)
            } else {
                // If player cannot move, stop.
                direction.set(to: .Stop)
                speed = position.move(to: .Stop)
            }
        }

        //
        // Update position and direction
        //
        sprite.setPosition(sprite_number, x: position.x, y: position.y)

        if direction.isChanging() {
            direction.update()
            draw(to: direction.get())
        }
    }

    /// Draw and animate  player in the direction
    /// - Parameter direction: Direction
    func draw(to direction: EnDirection) {
        switch direction {
            case .Right : sprite.startAnimation(sprite_number, sequence: [0,1,2]  , timePerFrame: 0.05, repeat: true)
            case .Left  : sprite.startAnimation(sprite_number, sequence: [32,33,2], timePerFrame: 0.05, repeat: true)
            case .Up    : sprite.startAnimation(sprite_number, sequence: [16,17,2], timePerFrame: 0.05, repeat: true)
            case .Down  : sprite.startAnimation(sprite_number, sequence: [48,49,2], timePerFrame: 0.05, repeat: true)
            case .Stop  : sprite.stopAnimation(sprite_number)
            case .None  : sprite.draw(sprite_number, x: position.x, y: position.y, texture: 2)
        }
    }
    
    /// Draw player disappeared animation (Player Miss)
    func drawPlayerDisappeared() {
        sprite.startAnimation(sprite_number, sequence: [3,4,5,6,7,8,9,10,11,12,13,13,14], timePerFrame: 0.13, repeat: false)
    }
    
    /// Clear player
    func clear() {
        sprite.stopAnimation(sprite_number)
        sprite.clear(sprite_number)
        drawTargetPosition(show: false)
    }
    
    func setTargetPosition(x: Int, y:Int) {
        let position = CgPosition(x: CGFloat(x), y: CGFloat(y))
        targetPosition.set(position)
        drawTargetPosition(show: true)
    }

    private func decideDirectionByTarget(forcedDirectionChange: Bool = false) -> EnDirection {
        let currentDirection = direction.get()
        var nextDirection: EnDirection  = .None
        let allDirections: [EnDirection] = [.Up, .Down, .Left, .Right]
        var minDistance = MAZE_MAX_DISTANCE

            for _direction in allDirections {
                if _direction != currentDirection.getReverse() || forcedDirectionChange {
                    if canMove(to: _direction) {
                        let deltaColumn = position.column + _direction.getHorizaontalDelta() - targetPosition.column
                        let deltaRow = position.row + _direction.getVerticalDelta() - targetPosition.row
                        let distance = deltaColumn * deltaColumn + deltaRow * deltaRow
                        if distance < minDistance {
                            minDistance = distance
                            nextDirection = _direction
                        }
                    }
                }
            }
           
            if nextDirection == .None {
                nextDirection = direction.getNext()
            }

        return nextDirection
    }

    func drawTargetPosition(show: Bool) {
        let spriteNumber = EnActor.TargetPacman.getSpriteNumber()
        if show {
            sprite.draw(spriteNumber, x: targetPosition.x, y: targetPosition.y, texture: 24)
            sprite.startAnimation(spriteNumber, sequence: [24,25,26,27], timePerFrame: 0.10, repeat: true)
        } else {
            sprite.stopAnimation(spriteNumber)
            sprite.clear(spriteNumber)
        }
    }
    
}

