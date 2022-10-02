//
//  GameScene.swift
//  0006_GamePlayTest
//
//  Created by Kikutada on 2020/08/11.
//  Copyright © 2020 Kikutada All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    /// Main object with main game sequence
    private var gameMain: CgGameMain!
    
    /// Points for Swipe operation
    private var startPoint: CGPoint = CGPoint.init()
    private var endPoint: CGPoint = CGPoint.init()

    // MotionManager for accel
    private var motionManager: CMMotionManager!
    
    override func didMove(to view: SKView) {

        //  Create and start game sequence.
        gameMain  = CgGameMain(skscene: self)
        gameMain.startSequence()
        
        // Create motion manager
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.05

        motionManager.startAccelerometerUpdates(
            to: OperationQueue.current!, withHandler: {
                (accelData: CMAccelerometerData?, errorOC: Error?) in self.sendAccelEvent(acceleration: accelData!.acceleration)
            }
        )
    }

    // moton event
    func sendAccelEvent(acceleration: CMAcceleration){
        let x_diff: Int = Int(acceleration.x * 100)
        let y_diff: Int = Int(acceleration.y * 100)

        if abs(x_diff) > abs(y_diff) {
            gameMain.sendEvent(message: .Accel, parameter: [Int(x_diff > 0 ? EnDirection.Right.rawValue : EnDirection.Left.rawValue)])
        } else {
            gameMain.sendEvent(message: .Accel, parameter: [Int(y_diff > 0 ? EnDirection.Up.rawValue : EnDirection.Down.rawValue)])
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get start touchpoint for swipe.
        if let t = touches.first {
            let location = t.location(in: self)
            startPoint = CGPoint(x: location.x, y: location.y)
        }
        gameMain.sendEvent(message: .Touch, parameter: [Int(startPoint.x), Int(startPoint.y)])
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get end touchpoint for swipe.
        if let t = touches.first {
            let location = t.location(in: self)
            endPoint = CGPoint(x: location.x, y: location.y)
            
            let x_diff = endPoint.x - startPoint.x
            let y_diff = endPoint.y - startPoint.y

            // Send swipe message to GameMain.
            if abs(x_diff) > abs(y_diff) {
                gameMain.sendEvent(message: .Swipe, parameter: [Int(x_diff > 0 ? EnDirection.Right.rawValue : EnDirection.Left.rawValue)])
            } else {
                gameMain.sendEvent(message: .Swipe, parameter: [Int(y_diff > 0 ? EnDirection.Up.rawValue : EnDirection.Down.rawValue)])
            }

        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered.

        // Send update message every 16ms.
        gameMain.sendEvent(message: .Update, parameter: [SYSTEM_FRAME_TIME])
    }

}
