//
//  GameScene.swift
//  SushiNeko
//
//  Created by Aniruddha Madhusudan on 6/26/17.
//  Copyright © 2017 Aniruddha Madhusudan. All rights reserved.
//

import SpriteKit

/* Tracking enum for use with character and sushi side */
enum Side {
    case none, left, right
}
/* Tracking enum for the game state */
enum GameState {
    case title, ready, playing, gameOver
}

class GameScene: SKScene {
    var sushiBasePiece: SushiPiece!
    var character: Character!
    var sushiTower: [SushiPiece] = []
    /* Game management */
    var state: GameState = .title
    var playButton: MSButtonNode!
    var healthBar: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var health: CGFloat = 1.0 {
        didSet {
            /* Scale health bar between 0.0 -> 1.0 e.g 0 -> 100% */
            if health > 1.0 { health = 1.0 }
            healthBar.xScale = health
        }
    }
    var score: Int = 0 {
        didSet {
            /* Update score */
            scoreLabel.text = String(score)
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        /* Connect Game objects */
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        character = childNode(withName: "character") as! Character
        playButton = childNode(withName: "playButton") as! MSButtonNode
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        
        playButton.selectedHandler = {
            /* Start game */
            self.state = .ready
        }
        
        /* Setup chopstick connections */
        sushiBasePiece.connectChopsticks()
        
        /* Manual add */
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        /* Add random pieces */
        addRandomPieces(total: 10)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if state == .title || state == .gameOver { return }
        if state == .ready {
            state = .playing
        }
        
        /* We only need a single touch */
        let touch = touches.first!
        
        /* Get touch position on the screen */
        let location = touch.location(in: self)
        
        /* Was touch on left/right side? */
        if location.x > size.width / 2 {
            character.side = .right
        } else {
            character.side = .left
        }
        
        /* Grab first sushi piece (one on top of the base */
        if let firstPiece = sushiTower.first {
            if character.side == firstPiece.side {
                
                gameOver()
                
                /* No need to continue as player is dead */
                return
            }
            /* Remove from sushi tower array */
            sushiTower.removeFirst()
            /* Animate the punched sushi piece */
            firstPiece.flip(character.side)
            
            /* Add a new sushi piece to the top of the tower */
            addRandomPieces(total: 1)
            
            /* Check character side against sushi piece side (this is our death collision check)*/
        }
        /* Increment health and score */
        health += 0.1
        score += 1
    }
    
    func gameOver() {
        state = .gameOver
        
        /* Turn all the sushi pieces red */
        for piece in sushiTower {
            piece.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        }
        
        /* Make the base turn red */
        sushiBasePiece.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        
        /* Make the player turn red */
        character.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        
        /* Change the play button selected handler */
        playButton.selectedHandler = {
            let skView = self.view as SKView!
            
            guard let scene = GameScene(fileNamed: "GameScene") as GameScene! else {
                return
            }
            
            scene.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if state != .playing {
            return
        }
        /* Decrease Health */
        health -= 0.02
        /* No health? */
        if health < 0 {
            gameOver()
        }
        moveTowerDown()
    }
    
    func addTowerPiece(side: Side) {
        /* Add a new sushi piece to the sushi tower */
        
        /* Copy original sushi piece */
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        /* access last tower piece properties */
        let lastPiece = sushiTower.last
        
        /* Add on top of last piece, default on first place */
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 55
        
        /* Increment Z to ensure that the piece is on top of the last piece */
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        
        /* Set side */
        newPiece.side = side
        
        /* Add sushi to scene */
        addChild(newPiece)
        
        /* Add sushi piece to sushi tower */
        sushiTower.append(newPiece)
 
    }
    
    func addRandomPieces(total: Int) {
        for _ in 1...total {

            /* Need to access last Piece's properties */
            let lastPiece = sushiTower.last
            
            /* Ensure that the player can survive */
            if lastPiece != nil && lastPiece!.side != .none {
                addTowerPiece(side: .none)
            } else {
                
                /* Rand number */
                let rand = arc4random_uniform(100)
                
                if rand < 45 {
                    /* 45% chance of a left piece */
                    addTowerPiece(side: .left)
                } else if rand < 90 {
                    /* 45% chance of a right piece */
                    addTowerPiece(side: .right)
                } else {
                    /* 10% chance of none */
                    addTowerPiece(side: .none)
                }
            }
        }
    }
    
    func moveTowerDown() {
        var n: CGFloat = 0
        for piece in sushiTower {
            let y = (n * 55) + 215
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
}




















