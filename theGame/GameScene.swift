//
//  GameScene.swift
//  theGame
//
//  Created by Lyt on 4/25/16.
//  Copyright (c) 2016 Lyt. All rights reserved.
//

import SpriteKit
import SceneKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Obstacle  : UInt32 = 0b1       // 1
    static let Aisle     : UInt32 = 0b10      // 2
    static let Placement : UInt32 = 0b100      // 4
}

protocol tellViewControllerAboutGameProtocol {
    func lightChanged(isOnFlower:Bool)
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var touchedNode = SKNode()
    
    var theLight:SKSpriteNode! = nil
    var theFlower:SKSpriteNode! = nil
    let lightNode = SKLightNode()
    
    let lightSize = CGSize(width: 20.0, height: 20.0)
    var mazeSize:Int!
    var newElementWidth:CGFloat!
    var newElementSize:CGSize!
    
    var theLightIsMoving = false
    var placementOnObtacle = false

    
    // delegate
    var lightDelegate:tellViewControllerAboutGameProtocol?
    
    override func didMoveToView(view: SKView) {
        //theLight = self.childNodeWithName("light") as? SKSpriteNode
        //theBulb = theLight.childNodeWithName("bulb") as? SKLightNode
        //theFlower = self.childNodeWithName("flower") as? SKSpriteNode
        
        initMaze(1)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.isEqualToNode(theLight) {
                theLightIsMoving = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if theLightIsMoving {
            for touch in touches {
                let location = touch.locationInNode(self)
                theLight.position = location
                
                let passagedNodes = self.nodesAtPoint(location)
                for node in passagedNodes {
                    switch node.name {
                    case "wall"?, "flower"?:
                        theLight.alpha = 0.5
                        placementOnObtacle = true
                    default:
                        theLight.alpha = 1.0
                        placementOnObtacle = false
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        theLightIsMoving = false
        
        if placementOnObtacle {
            theLight.position = CGPoint(x: (self.view?.frame.height)!/3 - lightSize.width/2,
                                        y: (self.view?.frame.height)!/3 - lightSize.height/2)
            placementOnObtacle = false
            theLight.alpha = 1.0
        }
        
        // check if any physics body is in the light way
//        let somethingInLightWay:Bool = self.physicsWorld.bodyAlongRayStart(theLight.position, end: theFlower.position) == nil ? true : false
//        lightDelegate?.lightChanged(somethingInLightWay)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    // MARK: Initialize the maze
    func initMaze(level:Int) {
        let myLevelReader = levelReader(level: level)
        mazeSize = myLevelReader.getMazeSize()
        
        // draw contents
        for i in 0..<mazeSize {
            for j in 0..<mazeSize {
                let elementType = myLevelReader.getElementTypeInPosition(i, y: j)
                newElementWidth = (self.view?.frame.width)!/CGFloat(mazeSize)
                newElementSize = CGSize(width: newElementWidth, height: newElementWidth)
                var newElement:SKSpriteNode = SKSpriteNode()
                
                switch elementType {
                case 0:
                    //ground
                    newElement = ground(size: newElementSize)
                    newElement.lightingBitMask = 1
                    newElement.shadowedBitMask = 0
                    newElement.shadowCastBitMask = 0
                    newElement.zPosition = 0
                    newElement.name = "ground"
                    
//                    newElement.physicsBody = SKPhysicsBody(rectangleOfSize: newElementSize) // 1
//                    newElement.physicsBody?.dynamic = false // 2
//                    newElement.physicsBody?.categoryBitMask = PhysicsCategory.Aisle // 3
//                    newElement.physicsBody?.contactTestBitMask = PhysicsCategory.Placement // 4
//                    newElement.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
//                    newElement.physicsBody?.affectedByGravity = false
                    
                case 1:
                    // wall
                    newElement = wall(size: newElementSize)
                    newElement.lightingBitMask = 1
                    newElement.shadowCastBitMask = 1
                    newElement.zPosition = 0
                    newElement.name = "wall"
                    
//                    newElement.physicsBody = SKPhysicsBody(rectangleOfSize: newElementSize) // 1
//                    newElement.physicsBody?.dynamic = false // 2
//                    newElement.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle // 3
//                    newElement.physicsBody?.contactTestBitMask = PhysicsCategory.Placement // 4
//                    newElement.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
//                    newElement.physicsBody?.affectedByGravity = false
                    
                case 9:
                    newElement = ground(size: newElementSize)
                    newElement.lightingBitMask = 1
                    newElement.shadowedBitMask = 0
                    newElement.shadowCastBitMask = 0
                    newElement.zPosition = 0
                    newElement.name = "ground"
                    
                    theFlower = flower(size: lightSize)
                    theFlower.lightingBitMask = 1
                    theFlower.shadowCastBitMask = 1
                    theFlower.zPosition = 1
                    theFlower.name = "flower"
                    theFlower.position = CGPoint(x: CGFloat(i)*newElementWidth + newElement.frame.size.width/2, y: self.view!.frame.height - newElement.frame.size.height/2 - CGFloat(j)*newElementWidth)
                    
                    self.addChild(theFlower)
                    
                default:
                    print("element type fault")
                }
                newElement.position = CGPoint(x: CGFloat(i)*newElementWidth + newElement.frame.size.width/2, y: self.view!.frame.height - newElement.frame.size.height/2 - CGFloat(j)*newElementWidth)
                self.addChild(newElement)
                
            }
        }
        
        // light
        theLight = light(size: lightSize)
        theLight.position = CGPoint(x: (self.view?.frame.height)!/3, y: (self.view?.frame.height)!/3)
        theLight.zPosition = 1
        
//        theLight.physicsBody = SKPhysicsBody(rectangleOfSize: lightSize)
//        theLight.physicsBody?.dynamic = true
//        theLight.physicsBody?.categoryBitMask = PhysicsCategory.Placement
//        theLight.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
//        theLight.physicsBody?.collisionBitMask = PhysicsCategory.None
//        theLight.physicsBody?.affectedByGravity = false
//        theLight.physicsBody?.usesPreciseCollisionDetection = true
        
        lightNode.position = CGPointMake(0,0)
        lightNode.enabled = true
        lightNode.categoryBitMask = 1
        lightNode.falloff = 1.5
        lightNode.ambientColor = UIColor.whiteColor()
        lightNode.lightColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        lightNode.shadowColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        
        theLight.addChild(lightNode)
        self.addChild(theLight)
        
        /*
        let path = UIBezierPath(roundedRect: CGRect(x: (self.view?.frame.height)!/3, y: (self.view?.frame.height)!/3, width: 20.0, height: 20.0), cornerRadius: 2)
        let shape = SKShapeNode(path: path.CGPath)
        shape.strokeColor = SKColor.greenColor()
        shape.fillColor = SKColor.redColor()
        
        shape.glowWidth = 4
        shape.position = CGPoint(x: (self.view?.frame.height)!/3, y: (self.view?.frame.height)!/3)
        
        shape.addChild(lightNode)
        self.addChild(shape)
        
        
         let rectangle = UIBezierPath(rect:CGRect(x: 0, y: 0, width: 100, height: 200))
         let roundedRect = UIBezierPath(roundedRect:CGRect(x: -100, y: -100, width: 200, height: 200), cornerRadius:20)
         let oval = UIBezierPath(ovalInRect:CGRect(x: 0, y: 0, width: 100, height: 200))
         let customShape = UIBezierPath()
         
         customShape.moveToPoint(CGPoint(x: 0, y: 0))
         customShape.addLineToPoint(CGPoint(x: 0, y: 100))
         customShape.addCurveToPoint(CGPoint(x: 0, y: 0),
         controlPoint1:CGPoint(x: 100, y: 100),
         controlPoint2:CGPoint(x: 100, y: 0))
         
         customShape.closePath()
         */

    }
    
//    func placementDidCollideWithObstacle(obstacle:SKSpriteNode, placement:SKSpriteNode) {
//        
//        print("PO Collide")
//        placementOnObtacle = true
//        placement.alpha = 0.5
//        
//    }
//    
//    func placementDidCollideWithAisle(aisle:SKSpriteNode, placement:SKSpriteNode) {
//        
//        print("PA Collide")
//        placementOnObtacle = false
//        placement.alpha = 1.0
//        
//    }
//    
//    func didBeginContact(contact: SKPhysicsContact) {
//        
//        var firstBody: SKPhysicsBody
//        var secondBody: SKPhysicsBody
//        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
//            firstBody = contact.bodyA
//            secondBody = contact.bodyB
//        } else {
//            firstBody = contact.bodyB
//            secondBody = contact.bodyA
//        }
//        
//        if ((firstBody.categoryBitMask & PhysicsCategory.Aisle != 0) &&
//            (secondBody.categoryBitMask & PhysicsCategory.Placement != 0)) {
//            placementDidCollideWithAisle(firstBody.node as! SKSpriteNode, placement: secondBody.node as! SKSpriteNode)
//        }
//        
//        if ((firstBody.categoryBitMask & PhysicsCategory.Obstacle != 0) &&
//            (secondBody.categoryBitMask & PhysicsCategory.Placement != 0)) {
//            placementDidCollideWithObstacle(firstBody.node as! SKSpriteNode, placement: secondBody.node as! SKSpriteNode)
//        }
//        
//    }
    
}






