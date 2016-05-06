//
//  flower.swift
//  theGame
//
//  Created by vorain on 16/5/5.
//  Copyright © 2016年 Lyt. All rights reserved.
//

import Foundation
import SpriteKit

class flower: SKSpriteNode {
    
    init(size:CGSize) {
        //ground(size: size)
        let texture = SKTexture(imageNamed: "flower")
        super.init(texture: texture, color: UIColor.redColor(), size: size)
        //self.anchorPoint = CGPoint(x: 0.0, y: 1.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}