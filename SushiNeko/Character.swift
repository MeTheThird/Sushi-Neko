//
//  Character.swift
//  SushiNeko
//
//  Created by Aniruddha Madhusudan on 6/26/17.
//  Copyright © 2017 Aniruddha Madhusudan. All rights reserved.
//

import SpriteKit

class Character: SKSpriteNode {
    
    /* Character side */
    var side: Side = .left {
        didSet {
            if side == .left {
                xScale = 1
                position.x = 70
            } else {
                /* Flip character */
                xScale = -1
                position.x = 252
            }
            /* Load/Run punch action */
            let punch = SKAction(named: "Punch")!
            run(punch)
        }
    }
    
    /* You are required to implement this for your subclass to work */
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
