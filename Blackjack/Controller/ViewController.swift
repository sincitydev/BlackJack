////
////  ViewController.swift
////  Blackjack
////
////  Created by Joshua Ramos on 9/29/17.
////  Copyright © 2017 Krevalent. All rights reserved.
////
//
//import UIKit
//
//class ViewController: UIViewController {
//
//    @IBOutlet weak var gameStatusLabel: UILabel!
//    @IBOutlet weak var playerLabel: UILabel!
//    @IBOutlet weak var dealerLabel: UILabel!
//    @IBOutlet weak var playerBustLabel: UILabel!
//    @IBOutlet weak var dealerBustLabel: UILabel!
//    @IBOutlet weak var remainingLabel: UILabel!
//    
//    let game = BlackjackBrain()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a
//    }
//    
// 
//    
//    @IBAction func hitPlayerPressed(_ sender: Any) {
//        game.hitPlayer()
//        
//        let playersCards = "\(game.getPlayersHand())"
//        let playerInfo = "Did bust: \(game.didPlayerBust()) - Soft: \(game.getPlayerSoftValue()) Hard: \(game.getPlayerHardValue())"
//        self.playerLabel.text = playersCards
//        self.playerBustLabel.text = playerInfo
//        
//        self.remainingLabel.text = "\(game.getNumberOfRemainingCards())"
//        
//        gameStatusLabel.text = ""
//        
//        if game.didPlayerBust() {
//            hitDealerPressed(1)
//        }
//    }
//    
//    @IBAction func hitDealerPressed(_ sender: Any) {
//        let score = game.getPlayerHardValue() <= 21 ? game.getPlayerHardValue() : game.getPlayerSoftValue()
//        game.dealerPlays(scoreToBeat: score)
//        
//        let dealersCards = "\(game.getDealersHand())"
//        let dealerInfo = "Did bust: \(game.didDealerBust()) - Soft: \(game.getDealerSoftValue()) Hard: \(game.getDealerHardValue())"
//        self.dealerLabel.text = dealersCards
//        self.dealerBustLabel.text = dealerInfo
//        
//        self.remainingLabel.text = "\(game.getNumberOfRemainingCards())"
//        
//        gameStatusLabel.text = game.didPlayerWin() ? "You won" : "You lost"
//    }
//    
//    @IBAction func dealPressed(_ sender: Any) {
//        game.deal()
//        
//        let playersCards = "\(game.getPlayersHand())"
//        let playerInfo = "Did bust: \(game.didPlayerBust()) - Soft: \(game.getPlayerSoftValue()) Hard: \(game.getPlayerHardValue())"
//        self.playerLabel.text = playersCards
//        self.playerBustLabel.text = playerInfo
//        
//        
//        let dealersCards = "\(game.getDealersHand())"
//        let dealerInfo = "Did bust: \(game.didDealerBust()) - Soft: \(game.getDealerSoftValue()) Hard: \(game.getDealerHardValue())"
//        self.dealerLabel.text = dealersCards
//        self.dealerBustLabel.text = dealerInfo
//        
//        self.remainingLabel.text = "\(game.getNumberOfRemainingCards())"
//        
//        gameStatusLabel.text = ""
//    }
//}
//
