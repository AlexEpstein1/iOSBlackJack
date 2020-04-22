//
//  Deck.swift
//  Blackjack
//
//  Created by Matt Finch on 4/14/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation
import SpriteKit

class Deck {
    var cards: [Card]!
    
    func initialize(stackPosition: CGPoint) {
        cards = [Card]()
        for suit in 1...4 {
            for num in 2...14 {
                let c = Card()
                c.initialize(s: suit, n: num)
                c.img.zPosition = 10
                c.img.position = stackPosition
                c.img.size = CGSize(width: c.img.size.width * 0.4, height: c.img.size.height * 0.4)
                c.face.size = c.img.size
                c.face.position = c.img.position
                c.face.zPosition = 0
                cards.append(c)
            }
        }
        shuffle(n: cards.count)
    }
    
    func shuffle(n: Int) {
        for i in 0...(n - 1) {
            let j = Int.random(in: 0 ..< n)
            let temp = cards[i]
            cards[i] = cards[j]
            cards[j] = temp
        }
    }
}
