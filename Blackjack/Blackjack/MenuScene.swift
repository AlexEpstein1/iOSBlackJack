//
//  GameScene.swift
//  Blackjack
//
//  Created by Matt Finch on 4/14/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var game: GameManager!
    var logo: SKSpriteNode!
    var background: SKSpriteNode!
    var playButton: SKLabelNode!
    
    override func didMove(to view: SKView) {
        initializeMenu()
        game = GameManager()
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    private func initializeMenu() {
        var center = self.position
        if GameManager.first != nil {
            center = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        }
        background = SKSpriteNode(imageNamed: "menu_background")
        background.name = "background"
        background.zPosition = 1
        background.position = center
        background.size = self.size
        self.addChild(background)
        
        logo = SKSpriteNode(imageNamed: "logo")
        logo.zPosition = 2
        logo.position = CGPoint(x: center.x, y: center.y + self.size.height * 0.25)
        logo.size = CGSize(width: self.size.width * 0.4, height: self.size.width * 0.4)
        self.addChild(logo)
        
        playButton = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        playButton.zPosition = 2
        playButton.position = center
        playButton.fontSize = 40
        playButton.name = "playButton"
        playButton.text = "Play"
        playButton.fontColor = SKColor.white
        self.addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "playButton" {
                    print("pressed play")
                    startGame()
                    
                }
            }
        }
    }
   
    
    
    private func startGame() {
//        logo.run(SKAction.move(to: CGPoint(x: self.size.width * 0.5, y: self.size.height * 2), duration: 1))
//        playButton.run(SKAction.move(to: CGPoint(x: self.size.width * 0.5, y: self.size.height * 2), duration: 1))
        
        let reveal = SKTransition.reveal(with: .up, duration: 1.5)
        let newScene = SinglePlayerScene(size: self.size)
//        self.run(SKAction.wait(forDuration: 1.5)) {
//            self.scene?.view?.presentScene(newScene, transition: reveal)
//        }
        scene?.view?.presentScene(newScene, transition: SKTransition.crossFade(withDuration: 1.5))
    }
}


    

