//
//  SushiPiece.swift
//  SushiNeko
//
//  Created by Aniruddha Madhusudan on 6/26/17.
//  Copyright © 2017 Aniruddha Madhusudan. All rights reserved.
//

import SpriteKit

class SushiPiece: SKSpriteNode {
    
    /* Chopstick objects */
    var leftChopstick: SKSpriteNode!
    var rightChopstrick: SKSpriteNode!
    var side: Side = .none {
        didSet {
            switch side {
            case .left:
                /* Show left chopstick */
                leftChopstick.isHidden = false
                rightChopstrick.isHidden = true
            case .right:
                /* Show right chopstick */
                leftChopstick.isHidden = true
                rightChopstrick.isHidden = false
            case .none:
                /* Hide all chopsticks */
                leftChopstick.isHidden = true
                rightChopstrick.isHidden = true
            }
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
    
    func connectChopsticks() {
        /* Connect our child chopstick nodes */
        leftChopstick = childNode(withName: "leftChopstick") as! SKSpriteNode
        rightChopstrick = childNode(withName: "rightChopstick") as! SKSpriteNode
        /* Set the default side */
        side = .none
    }
    
    func flip(_ side: Side) {
        /* Flip the sushi out of the screen */
        
        
        var actionName: String = ""
        if side == .left {
            actionName = "FlipRight"
        } else if side == .right {
            actionName = "FlipLeft"
        }
        
        /* Load action */
        let flip = SKAction(named: actionName)!
        
        /* Create a node removal action */
        let remove = SKAction.removeFromParent()
        
        /* Build sequence, then run it */
        let sequence = SKAction.sequence([flip, remove])
        run(sequence)
    }
}
