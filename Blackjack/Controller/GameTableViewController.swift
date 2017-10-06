//
//  GameTableViewController.swift
//  Blackjack
//
//  Created by Joshua Ramos on 10/1/17.
//  Copyright © 2017 Krevalent. All rights reserved.
//

import UIKit

class GameTableViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var bettingSlider: UISlider!
    @IBOutlet weak var bettingLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var dealersHandLabel: UILabel!
    @IBOutlet weak var playersHandLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var blackjackLogoImage: UIImageView!
    
    @IBOutlet weak var allInButton: UIButton!
    var doubleTapGesture: UITapGestureRecognizer!
    var swipeRightGesture: UISwipeGestureRecognizer!
    var swipeDownGesture: UISwipeGestureRecognizer!
    
    var playersMoney = 500
    var playersBet = 0
    var blackjackGame = BlackjackBrain()
    var playerCardViews = [UIImageView]()
    var dealersCardViews = [UIImageView]()
    
    var playersHand: [card] {
        get {
            return blackjackGame.getPlayersHand()
        }
    }
    var dealersHand: [card] {
        get {
            return blackjackGame.getDealersHand()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let instructionsVC = UIStoryboard.init(name: "Instructions", bundle: nil).instantiateInitialViewController() as! InstructionsViewController
        
        if !userDefaults.bool(forKey: Literals.visitedBefore) {
            self.present(instructionsVC, animated: true, completion: nil)
        }
    }
    
    func setupGestures() {
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(stand(_:)))
        swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(hit(_:)))
        swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(clear(_:)))
        
        doubleTapGesture.numberOfTapsRequired = 2
        swipeDownGesture.direction = .down
        swipeRightGesture.direction = .right
        
        self.view.addGestureRecognizer(doubleTapGesture)
        self.view.addGestureRecognizer(swipeDownGesture)
        self.view.addGestureRecognizer(swipeRightGesture)
    }
    
    func setupView() {
        playersHandLabel.isHidden = true
        dealersHandLabel.isHidden = true
        statusLabel.isHidden = true
        doubleTapGesture.isEnabled = false
        swipeDownGesture.isEnabled = false
        swipeRightGesture.isEnabled = false
        
        statusLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        statusLabel.layer.shadowOpacity = 1
        statusLabel.layer.shadowRadius = 1
        statusLabel.layer.shadowColor = UIColor.black.cgColor
        
        
        updateView()
    }
    
    func updateView() {
        bettingLabel.text = "Betting: $\(bettingSlider.value)"
        bettingSlider.maximumValue = Float(playersMoney)
        bettingSlider.value = (bettingSlider.maximumValue / 2).rounded()
        bettingLabel.text = "Betting: $\(bettingSlider.value)"
        playersBet = Int(bettingSlider.value)
        moneyLabel.text = "$\(playersMoney - playersBet)"
    }
    
    func updateValuesOfHands(revealDealer reveal: Bool) {
        playersHandLabel.text = "Your hand: \(blackjackGame.getPlayerValue())"
        dealersHandLabel.text = "Dealer's hand "
        if reveal {
            dealersHandLabel.text! += "\(blackjackGame.getDealerValue())"
        } else {
            var cardValue: Int
            switch dealersHand[0] {
                case .spade(let value):
                    cardValue = value
                case .club(let value):
                    cardValue = value
                case .heart(let value):
                    cardValue = value
                case .diamond(let value):
                    cardValue = value
                case .backing:
                    cardValue = 0
            }
            
            if cardValue == 1 {
                cardValue = 11
            } else if cardValue == 11 || cardValue == 12 || cardValue == 13 {
                cardValue = 10
            }
            
            dealersHandLabel.text! += "\(cardValue)"
        }
    }
    @IBAction func allInButtonPressed(_ sender: Any) {
        playersBet = playersMoney
        dealButtonPressed(0)
    }
    
    @IBAction func dealButtonPressed(_ sender: Any) {
        // Dount allow new deal until player stands
        dealButton.isHidden = true
        bettingSlider.isHidden = true
        moneyLabel.isHidden = true
        bettingLabel.isHidden = true
        allInButton.isHidden = true
        dealersHandLabel.isHidden = false
        playersHandLabel.isHidden = false
        blackjackLogoImage.isHidden = true
        doubleTapGesture.isEnabled = true
        swipeDownGesture.isEnabled = true

        // MARK: - WORKOUT BETTING HERE
        //        playersMoney = Int(moneyLabel.text!)!
        //        bettingSlider.maximumValue = Float(playersMoney)
        //        bettingSlider.value = 0
        
        blackjackGame.deal()
        playerCardViews.removeAll()
        dealersCardViews.removeAll()
        
        // Create the playerCardViews
        for _ in playersHand {
            let cardView = getCardBacking()
            view.addSubview(cardView)
            playerCardViews.append(cardView)
        }
        
        // Create the dealers cardViews
        for i in 0..<dealersHand.count {
            let cardView: UIImageView
            if i == 0 {
                cardView = createCardView(forCard: dealersHand[i])
            } else {
                cardView = getCardBacking()
            }
            
            view.addSubview(cardView)
            dealersCardViews.append(cardView)
        }
        
        // Call the animations
        updateValuesOfHands(revealDealer: false)
        hitAnimation(forPlayer: true, cardViews: playerCardViews)
        hitAnimation(forPlayer: false, cardViews: dealersCardViews)
        updateValuesOfHands(revealDealer: false)
        
        if blackjackGame.getPlayerValue() == 21 {
            stand(doubleTapGesture)
        }
    }
    
    @objc func hit(_ sender: UISwipeGestureRecognizer) {
        // Adding the new card to screen
        blackjackGame.hitPlayer()
        updateValuesOfHands(revealDealer: false)
        
        let cardView = getCardBacking()
        playerCardViews.append(cardView)
        self.view.addSubview(cardView)
        
        hitAnimation(forPlayer: true, cardViews: playerCardViews)
        
        if blackjackGame.didPlayerBust() || blackjackGame.getPlayerValue() == 21 {
            stand(doubleTapGesture)
        }
    }
    
    @objc func stand(_ sender: UITapGestureRecognizer) {
        doubleTapGesture.isEnabled = false
        swipeDownGesture.isEnabled = false
        swipeRightGesture.isEnabled = true
        statusLabel.isHidden = false
        
        if blackjackGame.didPlayerBust() {
            statusLabel.text = "YOU BUSTED! xP"
            statusLabel.textColor = UIColor.red
            updateValuesOfHands(revealDealer: false)
            
            playersMoney -= playersBet
        } else {
            // reveals dealers cards
            dealersCardViews[1].flipRight(withNewImage: getUIImage(forCard: dealersHand[1])!)
            
            blackjackGame.dealerPlays(scoreToBeat: blackjackGame.getPlayerValue())
            
            for i in 2..<dealersHand.count {
                dealersCardViews.append(getCardBacking())
                self.view.addSubview(dealersCardViews[i])
            }
            
            hitAnimation(forPlayer: false, cardViews: dealersCardViews)
        
            if blackjackGame.didPlayerWin() {
                statusLabel.text = "YOU WIN! <3"
                statusLabel.textColor = UIColor.green
                updateValuesOfHands(revealDealer: true)
                
                playersMoney +=  playersBet
            } else if blackjackGame.didDraw() {
                statusLabel.text = "DRAW! -_-"
                statusLabel.textColor = UIColor.yellow
                updateValuesOfHands(revealDealer: true)
                
                playersMoney += 0
            } else {
                statusLabel.text = "YOU LOST! :("
                statusLabel.textColor = UIColor.red
                updateValuesOfHands(revealDealer: true)
                
                playersMoney -= playersBet

            }
        
        }
        
        // MARK: - Used for condition checking
        print("Players hand: \(blackjackGame.getPlayerValue())")
        print("Dealers hand: \(blackjackGame.getDealerValue())")
        print("Did player win: \(blackjackGame.didPlayerWin())")
        print("Did players draw: \(blackjackGame.didDraw())")
    }
    
    @objc func clear(_ sender: UISwipeGestureRecognizer) {
        clearAnimation(playerCardViews: playerCardViews, dealerCardViews: dealersCardViews)
        doubleTapGesture.isEnabled = false
        swipeDownGesture.isEnabled = false
        swipeRightGesture.isEnabled = false
        
        dealButton.isHidden = false
        bettingSlider.isHidden = false
        moneyLabel.isHidden = false
        bettingLabel.isHidden = false
        allInButton.isHidden = false
        playersHandLabel.isHidden = true
        dealersHandLabel.isHidden = true
        blackjackLogoImage.isHidden = false
        statusLabel.isHidden = true
        
        if playersMoney == 0 {
            playersMoney = 100
        }
        updateView()
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        playersBet = Int(sender.value.rounded())
        bettingLabel.text = "Betting: $\(playersBet)"
        let newTotal = playersMoney - Int(sender.value.rounded())
        moneyLabel.text = getMoneyString(forInt: newTotal)
        
    }    
}





extension GameTableViewController {
    func getMoneyString(forInt: Int) -> String {
        return "$\(forInt)"
        
    }
    
    func createCardView(forCard card: card) -> UIImageView {
        let cardWidth: CGFloat = 100
        let cardHeight: CGFloat = 128
        let midFrame = self.view.bounds.size.height / 2 - (cardHeight / 2)
        let offFrame = CGFloat(-1) * cardWidth
        let cardView = UIImageView(frame: CGRect(x: offFrame, y: midFrame, width: cardWidth, height: cardHeight))
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cardView.layer.shadowOpacity = 0.70
        cardView.image = getUIImage(forCard: card)
        
        return cardView
    }
    
    func getUIImage(forCard card: card) -> UIImage? {
        switch card {
        case .spade(let value):
            return UIImage(named: "\(value)_of_spades")
        case .heart(let value):
            return UIImage(named: "\(value)_of_hearts")
        case .club(let value):
            return UIImage(named: "\(value)_of_clubs")
        case .diamond(let value):
            return UIImage(named: "\(value)_of_diamonds")
        case .backing:
            return UIImage(named: "card_backing")
        }
    }
    
    func getCardBacking() -> UIImageView {
        return createCardView(forCard: card.backing)
    }
    
    
    func hitAnimation(forPlayer: Bool, cardViews: [UIImageView]) {
        if cardViews.count != 0 {
            var animationOffset: TimeInterval = 0.2
            var xOffset: CGFloat = 25
            let yOffset: CGFloat = 20
            var targetX: CGFloat
            var targetY: CGFloat
            
            let numberOfCards = CGFloat(cardViews.count)
            let imageWidth = cardViews[0].bounds.size.width
            let imageHeight = cardViews[0].bounds.size.height
            let totalWidth = imageWidth + (xOffset * (numberOfCards - CGFloat(1)))
            
            if forPlayer {
                targetX = (self.view.bounds.size.width - totalWidth) / 2
                targetY = (self.view.bounds.size.height - imageHeight - yOffset)
            } else {
                targetX = ((self.view.bounds.size.width - totalWidth) / 2) + totalWidth - imageWidth
                targetY = yOffset + 10
                
                xOffset = -1 * xOffset
            }
            
            for i in 0..<cardViews.count {
                UIView.animate(withDuration: animationOffset, animations: {
                    cardViews[i].frame = CGRect(x: targetX, y: targetY, width: imageWidth, height: imageHeight)
                    
                    targetX += xOffset
                    animationOffset = animationOffset <= 0.35 ?
                        animationOffset + 0.05 : 0.35
                }, completion: { (success) in
                    if success {
                        if forPlayer {
                            if cardViews[i].image != self.getUIImage(forCard: self.playersHand[i]) {
                                cardViews[i].flipLeft(withNewImage: self.getUIImage(forCard: self.playersHand[i])!)
                            }
                        } else {
                            if i != 1 && cardViews[i].image != self.getUIImage(forCard: self.dealersHand[i]){
                                cardViews[i].flipRight(withNewImage: self.getUIImage(forCard: self.dealersHand[i])!)
                            }
                        }
                    }
                })
            }
        } else {
            // bounce out on empty arrays
            return
        }
    }
    
    func clearAnimation(playerCardViews: [UIImageView], dealerCardViews: [UIImageView]) {
        if playerCardViews.count != 0 && dealerCardViews.count != 0 {
            let imageHeight = playerCardViews[0].bounds.size.height
            let imageWidth = playerCardViews[0].bounds.size.width
            let targetY = (self.view.bounds.size.height / 2) - (imageHeight / 1)
            let targetX = self.view.bounds.size.width + 20
            var animationOffset: TimeInterval = 0.2
            
            for i in 0..<playerCardViews.count {
                UIView.animate(withDuration: animationOffset, animations: {
                    playerCardViews[i].frame = CGRect(x: targetX, y: targetY, width: imageWidth, height: imageHeight)
                    
                    animationOffset = animationOffset <= 0.35 ?
                        animationOffset + 0.05 : 0.35
                }, completion: { (success) in
                    if success {
                        // MARK: - attempting to remove card, but still is in memory
                        playerCardViews[i].removeFromSuperview()
                    }
                })
            }
            
            for i in 0..<dealerCardViews.count {
                UIView.animate(withDuration: animationOffset, animations: {
                    dealerCardViews[i].frame = CGRect(x: targetX, y: targetY, width: imageWidth, height: imageHeight)
                    
                    animationOffset = animationOffset <= 0.35 ?
                        animationOffset + 0.05 : 0.35
                }, completion: { (success) in
                    if success {
                        // MARK: - attempting to remove card, but still is in memory
                        dealerCardViews[i].removeFromSuperview()
                    }
                })
            }
        } else {
            return
        }
    }
}
