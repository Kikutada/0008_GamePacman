//
//  GameViewController.swift
//  0006_GamePlayTest
//
//  Created by Kikutada on 2020/08/11.
//  Copyright © 2020 Kikutada All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    private var scene: SKScene!
    
    override func viewDidLoad() {
       super.viewDidLoad()
       
       if let view = self.view as! SKView? {
           
           let size = CGSize(width: BG_WIDTH*8, height: BG_HEIGHT*8)
           scene = GameScene(size: size)
           
           // Set background color to black.
           scene.backgroundColor = UIColor.black

           // Set the scale mode to scale to fit the window.
           scene.scaleMode = .aspectFit
           
           // Present the scene.
           view.presentScene(scene)
           
           view.ignoresSiblingOrder = true
           
           view.showsFPS = false
           view.showsNodeCount = false
       }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
