//
//  GameScene.swift
//  theGame
//
//  Created by Lyt on 4/25/16.
//  Copyright (c) 2016 Lyt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var theLight:SKSpriteNode! = nil
    var theLightIsMoving = false
    
    override func didMoveToView(view: SKView) {
        theLight = self.childNodeWithName("light") as? SKSpriteNode
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.isEqualToNode(theLight) {
                theLightIsMoving = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if theLightIsMoving == true {
            let location = touches.first?.locationInNode(self)
            theLight.position = location!
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        theLightIsMoving = false
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
