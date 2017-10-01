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
        
        if (dealerCurrentScore == 21 || dealerCurrentScore == 20) {
            return
        } else if dealerCurrentScore < 17 || dealerCurrentScore < challengingScore {
            hitDealer()
        } else {
            return
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
    func getPlayerSoftValue() -> Int {
        return totalValue(ofHand: playersCards, returnSoftValue: true)
    }
    
    // returns blackjack score value for required information
    func getPlayerHardValue() -> Int {
        return totalValue(ofHand: playersCards, returnSoftValue: false)
    }
    
    // returns blackjack score value for required information
    func getDealerSoftValue() -> Int {
        return totalValue(ofHand: dealersCards, returnSoftValue: true)
    }
    
    // returns blackjack score value for required information
    func getDealerHardValue() -> Int {
        return totalValue(ofHand: dealersCards, returnSoftValue: false)
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
        let hardValue = totalValue(ofHand: hand, returnSoftValue: false)
        let softValue = totalValue(ofHand: hand, returnSoftValue: true)
        return hardValue <= 21 ? hardValue : softValue
    }
    
    private func totalValue(ofHand hand: [card], returnSoftValue isSoft: Bool) -> Int {
        var totalValue = 0
        for eachCard in hand {
            switch eachCard {
            case .spade(let value):
                totalValue += cardValue(value, isSoft: isSoft)
            case .heart(let value):
                totalValue += cardValue(value, isSoft: isSoft)
            case .club(let value):
                totalValue += cardValue(value, isSoft: isSoft)
            case .diamond(let value):
                totalValue += cardValue(value, isSoft: isSoft)
            }
        }
        return totalValue
    }
    
    private func cardValue(_ card: Int, isSoft: Bool) -> Int {
        if (card == 1) {
            if isSoft {
                return 1
            } else {
                return 11
            }
        } else if (card == 11 || card == 12 || card == 13) {
            return 10
        } else {
            return card
        }
    }
}
