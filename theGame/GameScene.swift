//
//  GameScene.swift
//  theGame
//
//  Created by Lyt on 4/25/16.
//  Copyright (c) 2016 Lyt. All rights reserved.
//

import SpriteKit

protocol tellViewControllerAboutGameProtocol {
    func lightChanged(isOnFlower:Bool)
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var theLight:SKSpriteNode! = nil
    var theBulb: SKLightNode! = nil
    var theFlower:SKSpriteNode! = nil
    var theLightIsMoving = false
    
    // delegate
    var lightDelegate:tellViewControllerAboutGameProtocol?
    
    override func didMoveToView(view: SKView) {
        theLight = self.childNodeWithName("light") as? SKSpriteNode
        theBulb = theLight.childNodeWithName("bulb") as? SKLightNode
        theFlower = self.childNodeWithName("flower") as? SKSpriteNode
        
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
        
        // check if any physics body is in the light way
        let somethingInLightWay:Bool = self.physicsWorld.bodyAlongRayStart(theLight.position, end: theFlower.position) == nil ? true : false
        lightDelegate?.lightChanged(somethingInLightWay)
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
    }
    
}
