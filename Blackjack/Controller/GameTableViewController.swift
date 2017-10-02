//
//  GameTableViewController.swift
//  Blackjack
//
//  Created by Joshua Ramos on 10/1/17.
//  Copyright © 2017 Krevalent. All rights reserved.
//

import UIKit

class GameTableViewController: UIViewController {

    @IBOutlet weak var bettingSlider: UISlider!
    @IBOutlet weak var bettingLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var dealButton: UIButton!
    
    @IBOutlet weak var dealersHandLabel: UILabel!
    
    @IBOutlet weak var playersHandLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    var playersMoney = 500
    var blackjackGame = BlackjackBrain()
    var playersHand = [card]()
    var dealersHand = [card]()
    
    
    
    var playerCardViews = [UIImageView]()
    var dealersCardViews = [UIImageView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playersHandLabel.isHidden = true
        dealersHandLabel.isHidden = true
        
        moneyLabel.text = getMoneyString(forInt: playersMoney)
        bettingSlider.value = bettingSlider.minimumValue
        bettingLabel.text = "Betting: $\(bettingSlider.value)"
        bettingSlider.maximumValue = Float(playersMoney)
        
        let hitGetstureRecgonizer = UISwipeGestureRecognizer(target: self, action: #selector(hit(sender:)))
        
        let stayGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stay(sender:)))
        
        let endGestureRocognnizer = UISwipeGestureRecognizer(target: self, action: #selector(clear(sender:)))
        
        stayGestureRecognizer.numberOfTapsRequired = 2
        
        hitGetstureRecgonizer.direction = .down
        endGestureRocognnizer.direction = .right
        
        
        view.addGestureRecognizer(hitGetstureRecgonizer)
        view.addGestureRecognizer(stayGestureRecognizer)
        view.addGestureRecognizer(endGestureRocognnizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let instructionsVC = UIStoryboard.init(name: "Instructions", bundle: nil).instantiateInitialViewController() as! InstructionsViewController
        
        if !userDefaults.bool(forKey: Literals.visitedBefore)
        {
            self.present(instructionsVC, animated: true, completion: nil)
        }
    }
    
    @objc func hit(sender: UISwipeGestureRecognizer) {
        
        if playersHand.count == 0 {
            print("Need to deal before I can hit you")
        } else {
            blackjackGame.hitPlayer()
            playersHand = blackjackGame.getPlayersHand()
            
            // Adding the new card to screen
            let cardView = createCardView(forCard: playersHand[playersHand.count - 1])
            playerCardViews.append(cardView)
            self.view.addSubview(cardView)
            hitAnimation(forPlayer: true, cardViews: playerCardViews)
        }
    }
    
    @objc func stay(sender: UITapGestureRecognizer) {
        
        if dealersHand.count == 0 {
            print("Need to deal before you can stay")
        } else {
            print("Stay")
            
            // MARK: - CHANGE THIS LATER SO THAT BETTING AND WIN CONDITION CAN TAKE PLACE
            dealButton.isEnabled = true
            dealersCardViews[1].image = getUIImage(forCard: dealersHand[1])
            
            blackjackGame.dealerPlays(scoreToBeat: blackjackGame.getBestValue(ofHand: playersHand))
            dealersHand = blackjackGame.getDealersHand()
            
            for i in 2..<dealersHand.count {
                dealersCardViews.append(createCardView(forCard: dealersHand[i]))
                self.view.addSubview(dealersCardViews[i])
            }
            
            hitAnimation(forPlayer: false, cardViews: dealersCardViews)
        }
    }
    
    @objc func clear(sender: UISwipeGestureRecognizer) {
        clearAnimation(playerCardViews: playerCardViews, dealerCardViews: dealersCardViews)
        
        dealButton.isHidden = false
        bettingSlider.isHidden = false
        moneyLabel.isHidden = false
        bettingLabel.isHidden = false
        playersHandLabel.isHidden = true
        dealersHandLabel.isHidden = true
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        bettingLabel.text = "Betting: $\(sender.value.rounded())"
        let newTotal = playersMoney - Int(sender.value.rounded())
        moneyLabel.text = "\(newTotal)"
        
    }
    
    @IBAction func dealButtonPressed(_ sender: Any) {
        // Dount allow new deal until player stands
        dealButton.isHidden = true
        bettingSlider.isHidden = true
        moneyLabel.isHidden = true
        bettingLabel.isHidden = true
        dealersHandLabel.isHidden = false
        playersHandLabel.isHidden = false
        
        
        // MARK: - WORKOUT BETTING HERE
//        playersMoney = Int(moneyLabel.text!)!
//        bettingSlider.maximumValue = Float(playersMoney)
//        bettingSlider.value = 0
        
        
        
        blackjackGame.deal()
        playersHand = blackjackGame.getPlayersHand()
        dealersHand = blackjackGame.getDealersHand()
        
        playerCardViews = [UIImageView]()
        dealersCardViews = [UIImageView]()
  
        // Create the playerCardViews
        for card in playersHand {
            let cardView = createCardView(forCard: card)
            view.addSubview(cardView)
            playerCardViews.append(cardView)
        }
        
        // Create the dealers cardViews
        for i in 0..<dealersHand.count {
            let cardView: UIImageView
            if i == 0 {
                cardView = createCardView(forCard: dealersHand[0])
            } else {
                cardView = getCardBacking()
            }
     
            view.addSubview(cardView)
            dealersCardViews.append(cardView)
        }
        
        // Call the animations
        hitAnimation(forPlayer: true, cardViews: playerCardViews)
        hitAnimation(forPlayer: false, cardViews: dealersCardViews)
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
                        self.removeSubViews(fromSubviewArray: playerCardViews, orSpecificIndex: nil)
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
                        self.removeSubViews(fromSubviewArray: dealerCardViews, orSpecificIndex: nil)
                    }
                })
            }
        } else {
            return
        }
    }
    
    func removeSubViews(fromSubviewArray subview: [UIImageView], orSpecificIndex index: Int?) {
        if index == nil {
            for i in 0..<subview.count {
                subview[i].removeFromSuperview()
            }
        } else {
            subview[index!].removeFromSuperview()
        }
        
    }
}
