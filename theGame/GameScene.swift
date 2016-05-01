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
        //theLight = self.childNodeWithName("light") as? SKSpriteNode
        //theBulb = theLight.childNodeWithName("bulb") as? SKLightNode
        //theFlower = self.childNodeWithName("flower") as? SKSpriteNode
        
        initMaze(1)
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
        //let somethingInLightWay:Bool = self.physicsWorld.bodyAlongRayStart(theLight.position, end: theFlower.position) == nil ? true : false
        //lightDelegate?.lightChanged(somethingInLightWay)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    // MARK: Initialize the maze
    func initMaze(level:Int) {
        let myLevelReader = levelReader(level: level)
        let mazeSize = myLevelReader.getMazeSize()
        
        // draw contents
        for i in 0..<mazeSize {
            for j in 0..<mazeSize {
                let elementType = myLevelReader.getElementTypeInPosition(i, y: j)
                let newElementWidth = (self.view?.frame.width)!/CGFloat(mazeSize)
                let newElementSize = CGSize(width: newElementWidth, height: newElementWidth)
                var newElement:SKSpriteNode = SKSpriteNode()
                switch elementType {
                case 0:
                    //ground
                    newElement = ground(size: newElementSize)
                    newElement.lightingBitMask = 1
                    newElement.shadowedBitMask = 0
                    newElement.shadowCastBitMask = 0
                    newElement.zPosition = 0
                case 1:
                    // wall
                    newElement = wall(size: newElementSize)
                    newElement.lightingBitMask = 1
                    newElement.shadowCastBitMask = 1
                    newElement.zPosition = 0
                default:
                    print("element type fault")
                }
                newElement.position = CGPoint(x: CGFloat(i)*newElementWidth + newElement.frame.size.width/2, y: self.view!.frame.height - newElement.frame.size.height/2 - CGFloat(j)*newElementWidth)
                self.addChild(newElement)
            }
        }
        
        // light
        let lightSize = CGSize(width: 20.0, height: 20.0)
        theLight = light(size: lightSize)
        theLight.position = CGPoint(x: (self.view?.frame.height)!/3, y: (self.view?.frame.height)!/3)
        theLight.zPosition = 1
        
        let lightNode = SKLightNode()
        lightNode.position = CGPointMake(0,0)
        lightNode.enabled = true
        lightNode.categoryBitMask = 1
        lightNode.falloff = 1.5
        lightNode.ambientColor = UIColor.whiteColor()
        lightNode.lightColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        lightNode.shadowColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        
        theLight.addChild(lightNode)
        
        self.addChild(theLight)
    }
    
}






