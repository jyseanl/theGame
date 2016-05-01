//
//  ground.swift
//  theGame
//
//  Created by Lyt on 4/30/16.
//  Copyright © 2016 Lyt. All rights reserved.
//

import Foundation
import SpriteKit

class ground: SKSpriteNode {
    
    init(size:CGSize) {
        let texture = SKTexture(imageNamed: "ground")
        super.init(texture: texture, color: UIColor.redColor(), size: size)
        //self.anchorPoint = CGPoint(x: 0.0, y: 1.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}