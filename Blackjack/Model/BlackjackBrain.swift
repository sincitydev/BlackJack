//
//  BlackjackBrain.swift
//  Blackjack
//
//  Created by Joshua Ramos on 9/29/17.
//  Copyright © 2017 Krevalent. All rights reserved.
//

import Foundation

class BlackjackBrain {
    static let instance = BlackjackBrain()
    
    // Variables
    let MAX_NUMBER_OF_CARDS_IN_HAND = 11
    private let gameDeck = PlayingCards(withNumberOfdecks: 4, isShuffled: true)
    private var getCard: [card] {
        get {
            return gameDeck.retrieveDeck()
        }
    }
    
    // Keeps track of what cards players have in hand, and where game is in gameDeck
    private var playersCards = [card]()
    private var dealersCards = [card]()
    private var numberOfCardsUnplayed: Int
    
 
    init () {
        numberOfCardsUnplayed = gameDeck.retrieveDeck().count
    }
    
    // Empty's hand off all players and deals two cards to each
    func deal() {
        playersCards.removeAll()
        dealersCards.removeAll()
        
        for _ in 1...2 {
            hitPlayer()
            hitDealer()
        }
    }
    
    // Gives the player a card
    func hitPlayer() {
        if numberOfCardsUnplayed > 0 {
            numberOfCardsUnplayed -= 1
            playersCards.append(getCard[numberOfCardsUnplayed])
        } else {
            resetDeck()
            hitPlayer()
        }
    }
    
    // Dealer decides his moves -- pass in the score that the player got
    func dealerPlays(scoreToBeat score: Int) {
        let dealerCurrentScore = getBestValue(ofHand: dealersCards)
        let challengingScore = score <= 21 ? score : 0

        // removed this logic because house rules says dealer must hit until getting a 16. Then dealer must stop
//        if (dealerCurrentScore == 21 || dealerCurrentScore == 20) {
//            return
//        } else if dealerCurrentScore < 17 || dealerCurrentScore < challengingScore {
//            hitDealer()
//        } else {
//            return
//        }
        
        if (dealerCurrentScore >= 16) {
            return
        } else {
            hitDealer()
        }
        
        dealerPlays(scoreToBeat: challengingScore)
    }
    
    // returns true/false if the player recieved too many cards or player value > 21
    func didPlayerBust() -> Bool {
        if (playersCards.count > MAX_NUMBER_OF_CARDS_IN_HAND || getBestValue(ofHand: playersCards) > 21) {
            return true
        } else {
            return false
        }
    }
    
    // returns true/false if the dealer revieved too many cards or dealer value > 21
    func didDealerBust() -> Bool {
        if (dealersCards.count > MAX_NUMBER_OF_CARDS_IN_HAND || getBestValue(ofHand: dealersCards) > 21) {
            return true
        } else {
            return false
        }
    }
    
    // returns true/false if the player beat the dealer
    func didPlayerWin() -> Bool {
        let playerScore = getBestValue(ofHand: playersCards)
        let dealerScore = getBestValue(ofHand: dealersCards)
        
        if didPlayerBust() {
            return false
        } else if didDealerBust() && !didPlayerBust() {
            return true
        } else if (playerScore > dealerScore && playerScore <= 21) {
            return true
        } else {
            return false
        }
    }
    
    // return true/false if the player == dealer hand
    func didDraw() -> Bool {
        let playerScore = getBestValue(ofHand: playersCards)
        let dealerScore = getBestValue(ofHand: dealersCards)
        return playerScore == dealerScore ? true : false
    }
    
    // returns the array that makes up the players cards
    func getPlayersHand() -> [card] {
        return playersCards
    }
    
    // returns the array that makes up the dealers cards
    func getDealersHand() -> [card] {
        return dealersCards
    }
    
    // returns blackjack score value for required information
    func getPlayerValue() -> Int {
        return getBestValue(ofHand: playersCards)
    }
    
    func getDealerValue() -> Int {
        return getBestValue(ofHand: dealersCards)
    }
    
    // returns blackjack score value for required information
    func getNumberOfRemainingCards() -> Int {
        return numberOfCardsUnplayed
    }
}

extension BlackjackBrain {
    private func hitDealer() {
        if numberOfCardsUnplayed > 0 {
            numberOfCardsUnplayed -= 1
            dealersCards.append(getCard[numberOfCardsUnplayed])
        } else {
            resetDeck()
            hitDealer()
        }
    }
    
    private func resetDeck() {
        gameDeck.reshuffleDeck()
        numberOfCardsUnplayed = gameDeck.retrieveDeck().count
    }
    
    private func getBestValue(ofHand hand: [card]) -> Int {
        var totalValue = 0
        var numberOfAces = 0
        var valueOfAces = 0
        
        for eachCard in hand {
            switch eachCard {
            case .spade(let value):
                if value == 1 {
                    numberOfAces += 1
                } else {
                    totalValue += cardValue(value)
                }
            case .heart(let value):
                if value == 1 {
                    numberOfAces += 1
                } else {
                    totalValue += cardValue(value)
                }
            case .club(let value):
                if value == 1 {
                    numberOfAces += 1
                } else {
                    totalValue += cardValue(value)
                }
            case .diamond(let value):
                if value == 1 {
                    numberOfAces += 1
                } else {
                    totalValue += cardValue(value)
                }
            case .backing:
                break
            }
        }
        
        valueOfAces = 11 * numberOfAces
        for _ in 0..<numberOfAces {
            if (totalValue + valueOfAces <= 21) {
                return totalValue + valueOfAces
            } else {
                valueOfAces -= 10
            }
        }
        
        // returns soft value if busted
        return totalValue + numberOfAces
    }
    

    private func cardValue(_ card: Int) -> Int {
        if (card == 11 || card == 12 || card == 13) {
            return 10
        } else {
            return card
        }
    }
}
