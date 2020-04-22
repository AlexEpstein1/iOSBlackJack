//
//  SinglePlayerScene.swift
//  Blackjack
//
//  Created by Matt Finch on 4/14/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation
import SpriteKit




class SinglePlayerScene: SKScene {
    var deck: Deck!
    var cards: [Card]! // The deck
    var cardShoe: CGPoint! // Location where cards are dealt from
    var cardIndex: Int! // Keeps track of where we are in the deck
    var player: Player!
    var dealer: Player!
    var hitButton: SKSpriteNode!
    var buttons: [SKSpriteNode]!
    var background: SKSpriteNode!
    var gameState: Int! // Controls the state of the game
    var playerScore: SKLabelNode! // Hand value labels for player
    var dealerScore: SKLabelNode! // Hand value labels for player
    var result: SKLabelNode! // Result of the round
    var backButton: SKLabelNode!
    
    override func didMove(to view: SKView) {
        initializeGame()
    }
    
    private func initializeGame() {
        GameManager.first = true
        cardShoe = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.55)
        player = Player(p: CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.3))
        dealer = Player(p: CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.8))
        
//        playerScore = SKLabelNode()
//        playerScore.fontSize = 30
//        playerScore.position =
        
        result = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        result.zPosition = 2
        result.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.55)
        result.fontSize = 50
        result.text = ""
        result.fontColor = SKColor.white
        self.addChild(result)
        
//        backButton = SKSpriteNode(imageNamed: "backbutton")
        backButton = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        backButton.fontSize = 50
        backButton.fontColor = SKColor.white
        backButton.zPosition = 2
        backButton.text = "Menu"
        backButton.name = "back"
//        backButton.size = CGSize(width: self.size.width * 0.2, height: self.size.width * 0.5)
        backButton.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.9)
        self.addChild(backButton)
        
        playerScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        playerScore.zPosition = 2
        playerScore.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
        playerScore.fontSize = 40
        playerScore.text = ""
        playerScore.fontColor = SKColor.white
        self.addChild(playerScore)
        
        dealerScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        dealerScore.zPosition = 2
        dealerScore.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        dealerScore.fontSize = 40
        dealerScore.text = "Dealer"
        dealerScore.fontColor = SKColor.white
        self.addChild(dealerScore)
        
        background = SKSpriteNode(imageNamed: "game_background")
        background.zPosition = 1
        background.size = self.size
        background.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        self.addChild(background)
        
        buttons = [SKSpriteNode]()
        buttons.append(SKSpriteNode(imageNamed: "hit"))
        buttons.append(SKSpriteNode(imageNamed: "stay"))
        buttons.append(SKSpriteNode(imageNamed: "double"))
        buttons.append(SKSpriteNode(imageNamed: "split"))
        
        for i in 0...3 {
            buttons[i].name = String(i)
            buttons[i].zPosition = 4
        }
        
        for i in 0...2 {
            buttons[i].position = CGPoint(x: self.size.width * 0.5, y: self.size.width * 0.15)
            buttons[i].position.x += CGFloat(i - 1) * self.size.width * 0.3
            buttons[i].size = CGSize(width: self.size.width * 0.25, height: self.size.width * 0.1)
            self.addChild(buttons[i])
        }
        
        cards = [Card]()
        cardIndex = 0
        for suit in 1...4 {
            for num in 2...14 {
                let c = Card()
                c.initialize(s: suit, n: num)
                c.img.position = cardShoe
                c.img.zPosition = 10
                c.img.size = CGSize(width: self.size.width * 0.16, height: self.size.width * 0.2)
                c.face.size = c.img.size
                c.face.position = c.img.position
                c.face.zPosition = 0
                cards.append(c)
            }
        }
        
        cards.shuffle()
        self.addChild(cards[51].img)
        
        newHand()
        gameState = 1
    }
    
    func checkAces(user: Player) {
        // checks if the user has aces adjusts hand value if they bust
        
        for i in user.hand {
            if cards[i].ace && user.handValue > 21 {
                user.handValue -= 10
                cards[i].ace = false
            }
        }
    }
    
    func dealerTurn() {
        // Player stays, now it's dealer's turn
        
//        checkAces(user: dealer)
        
        adjustCards(user: dealer, factor: 0.2)
        flipCard(i: 1) // flip their face down card
        
        var dealVal = dealer.handValue
        var amountToAdd = 0
        while dealVal < 17 {
            self.addChild(cards[cardIndex + amountToAdd].img)
            dealVal += cards[cardIndex + amountToAdd].num
            if cards[cardIndex + amountToAdd].ace && dealVal > 21 {
                dealVal -= 10
//                cards[cardIndex + amountToAdd].ace = false
            }
            amountToAdd += 1
        }
        
        if amountToAdd > 0 {
            for i in 1...amountToAdd {
                cards[i+cardIndex-1].img.run(SKAction.wait(forDuration: Double(i-1) * 1.6)) {
                    self.checkAces(user: self.dealer)
                    self.dealCard(user: self.dealer, flip: true)
                    self.dealerScore.text = String(self.dealer.handValue)
                }
            }
        }
        
        background.run(SKAction.wait(forDuration: (Double(amountToAdd)) * 1.6)) {
            print(self.dealer.handValue)
            self.dealerScore.text = String(self.dealer.handValue)

//            self.dealer.handValue = dealVal
            self.gameResult()
        }
        
        self.run(SKAction.wait(forDuration: (Double(amountToAdd)) * 1.6 + 3.0)) {
            self.cleanUp()
        }
        
        
    }
    
    func gameResult() {
        result.run(SKAction.fadeIn(withDuration: 1.5))
        if player.handValue > 21 {
            result.text = "You Lose!"
            self.run(SKAction.wait(forDuration: 3.0)) {
                self.cleanUp()
            }
        } else if dealer.handValue > 21 {
            result.text = "You Win!"
        } else if dealer.handValue > player.handValue {
            result.text = "You Lose!"
        } else if dealer.handValue == player.handValue {
            result.text = "It's A Draw!"
        } else {
            result.text = "You Win!"
        }

    }
    
    func cleanUp() {
        for i in 0...cardIndex {
            cards[i].face.run(SKAction.wait(forDuration: Double(i) * 0.1)) {
                self.cards[i].face.zPosition = 2
                self.cards[i].face.run(SKAction.move(to: self.cardShoe, duration: 0.4))
            }
        }
        
        self.run(SKAction.wait(forDuration: Double(cardIndex) * 0.1 + 0.8)) {
            self.removeAllChildren()
            let reveal = SKTransition.reveal(with: .down, duration: 0)
            let newScene = SinglePlayerScene(size: self.size)
            self.scene?.view?.presentScene(newScene, transition: SKTransition.crossFade(withDuration: 1.0))
            print("card index: " + String(self.cardIndex))
        }
    }
    
    //  deals a card to the inputted position
    func dealCard(user: Player, flip: Bool) {
        user.addVal(c: cards[cardIndex], i: cardIndex)
        checkAces(user: user)

        playerScore.text = String(player.handValue)
//        dealerScore.text = String(dealer.handValue)
        
        if !flip {
            cards[cardIndex].img.run(SKAction.move(to: user.position, duration: 0.5))
        }
        var c: Int
        c = cardIndex
        
        if cardIndex > 0 {
            cards[cardIndex].img.zPosition = cards[cardIndex-1].img.zPosition + 1
        }
        if flip {
//            cards[cardIndex].img.run(SKAction.wait(forDuration: 0.5)) {
                adjustCards(user: user, factor: 1.2 / Double(user.hand.count) * 0.5)
//            }
            cards[c].img.run(SKAction.wait(forDuration: 0.4)) {
                self.flipCard(i: c)
            }
        }
        cardIndex += 1
    }
    
    func updateHand() {
        // if the player busts, losing screen
        if player.handValue > 21 {
            print("Bust, dealer wins")
            gameState = 4
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                switch gameState {
                case 1:
                    // Player's turn
                    if node.name == "0" {
                        // player presses hit me
                        self.addChild(cards[cardIndex].img)
                        dealCard(user: player, flip: true)
                        checkAces(user: player)
                        if player.handValue > 21 {
                            gameResult()
                            gameState = 2
                        }
                    } else if node.name == "1" {
                        // player stays, move to dealer
                        gameState = 2
                        dealerTurn()
                    } else if node.name == "back" {
                        let newScene = GameScene(size: self.size)
                        self.scene?.view?.presentScene(newScene, transition: SKTransition.crossFade(withDuration: 1.0))
                    }
                default: break
                }
                
            }
        }
    }
    
    private func newHand() {
        
        // Add card images to scene
        for i in 0...3 {
            self.addChild(cards[i].img)
        }
        
        // Animations for dealing to player and dealer
        for i in 0...1 {
            cards[cardIndex].img.run(SKAction.wait(forDuration: Double(i))) {
                self.dealCard(user: self.player, flip: false)
            }
            cards[cardIndex].img.run(SKAction.wait(forDuration: Double(i) + 0.5)) {
                self.dealCard(user: self.dealer, flip: false)
            }
        }
        cards[cardIndex].img.run(SKAction.wait(forDuration: 1.6)) {
            self.adjustCards(user: self.player, factor: 0.2)
        }
        cards[cardIndex].img.run(SKAction.wait(forDuration: 2.1)) {
            self.adjustCards(user: self.dealer, factor: 0.05)
        }
        cards[0].img.run(SKAction.wait(forDuration: 1.9)) {
            self.flipCard(i: 0)
            self.flipCard(i: 2)
        }
        cards[3].img.run(SKAction.wait(forDuration: 2.4)) {
            self.flipCard(i: 3)
        }
        
        checkAces(user: player)
    }
    

    
    func adjustCards(user: Player, factor: Double) {
        for i in 1...user.hand.count {
            let newX = (Double(i) - Double(user.hand.count + 1) * 0.5) * factor
            let newP = CGPoint(x: self.size.width * 0.5 + CGFloat(newX) * self.size.width, y: user.position.y)
            cards[user.hand[i-1]].img.run(SKAction.move(to: newP, duration: 0.3))
            cards[user.hand[i-1]].face.run(SKAction.move(to: newP, duration: 0.3))
        }
    }
    
    func newCard() {
       cardIndex += 1
       if cardIndex > 51 {
           cards.shuffle()
           cardIndex = 0
       }
    }
    
    func flipCard(i: Int) {
        self.cards[i].face.size = self.cards[i].img.size
        self.cards[i].face.position = self.cards[i].img.position
        self.cards[i].face.zPosition = self.cards[i].img.zPosition + 4
        self.cards[i].face.alpha = 0.0
        self.addChild(self.cards[i].face)
        self.cards[i].face.run(SKAction.fadeIn(withDuration: 0.2))
        self.cards[i].img.run(SKAction.fadeOut(withDuration: 0.2))
        self.cards[i].img.run(SKAction.wait(forDuration: 0.2)) {
            self.cards[i].img.removeFromParent()
        }
    }
    
    class Player {
        var position: CGPoint
        var handValue: Int
        var hand: [Int]
        
        init(p: CGPoint) {
            position = p
            handValue = 0
            hand = [Int]()
        }
        
        func addVal(c: Card, i: Int) {
            hand.append(i)
            handValue += c.num
        }
    }
    
  
    class Dealer {
        var position: CGPoint
        var handValue: Int
       
        
        init(p: CGPoint) {
            position = p
            handValue = 0
        }
        
        func dealCard(flip: Bool, i: Int) {
            
        }
    }
}
