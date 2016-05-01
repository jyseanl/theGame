//
//  light.swift
//  theGame
//
//  Created by Lyt on 4/30/16.
//  Copyright © 2016 Lyt. All rights reserved.
//

import Foundation
import SpriteKit


class light: SKSpriteNode {
    
    init(size:CGSize) {
        let texture = SKTexture(imageNamed: "light")
        super.init(texture: texture, color: UIColor.redColor(), size: size)
        //self.anchorPoint = CGPoint(x: 0.0, y: 1.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}