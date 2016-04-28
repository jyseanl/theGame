//
//  GameViewController.swift
//  theGame
//
//  Created by Lyt on 4/25/16.
//  Copyright (c) 2016 Lyt. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, tellViewControllerAboutGameProtocol {

    @IBOutlet var mazeView: SKView!
    @IBOutlet var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            mazeView.showsFPS = true
            mazeView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            mazeView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            //scene.size = CGSize(width: 100.0, height: 100.0)
            
            scene.lightDelegate = self
            
            mazeView.presentScene(scene)
        }
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // delegate functions
    func lightChanged(isOnFlower: Bool) {
        if isOnFlower == true {
            infoLabel.text = "Light on Flower"
        }else{
            infoLabel.text = "No Light"
        }
    }
}
