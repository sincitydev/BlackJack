//
//  BlackjackFramework.swift
//  Blackjack
//
//  Created by Joshua Ramos on 9/29/17.
//  Copyright © 2017 Krevalent. All rights reserved.
//

import Foundation

// information that makes up a card
enum card {
    case spade(Int)
    case heart(Int)
    case club(Int)
    case diamond(Int)
    case backing
}

class PlayingCards {
    // holds the collection of all cards
    private var gameDeck = [card]()
    
    // tells the object how many complete decks to include in the game deck
    init (withNumberOfdecks numberOfDecks: Int, isShuffled shuffled: Bool) {
        for _ in 1...numberOfDecks {
            self.gameDeck += getNewDeck()
        }
        
        if shuffled {
            self.gameDeck = shuffleOf(deck: gameDeck)
        }
    }
    
    // returns the game deck
    func retrieveDeck() -> [card] {
        return gameDeck
    }
    
    // shuffles the game deck
    func reshuffleDeck() {
        gameDeck = shuffleOf(deck: gameDeck)
    }
}

extension PlayingCards {
    // appends a whole set of new cards in order
    private func getNewDeck() -> [card] {
        var deck = [card]()
        for i in 1...13 { deck.append(card.spade(i))   }
        for i in 1...13 { deck.append(card.heart(i))   }
        for i in 1...13 { deck.append(card.club(i))    }
        for i in 1...13 { deck.append(card.diamond(i)) }
        return deck
    }
    
    // rearranges the game deck randomly
    private func shuffleOf(deck: [card]) -> [card] {
        var originalDeck = deck
        var shuffledDeck = [card]();
        
        for _ in 0..<originalDeck.count
        {
            let rand = Int(arc4random_uniform(UInt32(originalDeck.count)))
            
            shuffledDeck.append(originalDeck[rand])
            
            originalDeck.remove(at: rand)
        }
        return shuffledDeck
    }
}
