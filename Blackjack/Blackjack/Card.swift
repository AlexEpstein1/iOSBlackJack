//
//  Card.swift
//  Blackjack
//
//  Created by Matt Finch on 4/14/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation
import SpriteKit

class Card: NSObject {
    
    var suit: Int!
    var num: Int!
    var img: SKSpriteNode!
    var face: SKSpriteNode!
    var front: Bool!
    var name: String!
    
    override init() {
        
    }

    func initialize(s: Int, n: Int) {
        suit = s
        num = n
        img = SKSpriteNode(imageNamed: "card-back")
        img.zPosition = 5
        var s = ""
        switch(suit) {
        case 1: s = "D"
        break;
        case 2: s = "S"
        break;
        case 3: s = "C"
        break;
        case 4: s = "H"
        break;
        default:
            break;
        }
        name = String(format: "%d%@", num, s)
        face = SKSpriteNode(imageNamed: name)
        if num == 14 {
            num = 11
        } else if num > 10 {
            num = 10
        }

    }
    
    func faceUp() {
        let c = SKSpriteNode(imageNamed: name!)
        c.size = img.size
        c.position = img.position
        c.zPosition = 11
        img.removeFromParent()
        c.alpha = 0.0
//        GameScene.addThisChild(image: c)
        c.run(SKAction.fadeIn(withDuration: 0.2))
        img.run(SKAction.wait(forDuration: 3)) {
        self.img.isHidden = true
        self.img = c
        }
    
    }
    
}

