//
//  InstructionsViewController.swift
//  Blackjack
//
//  Created by Amanuel Ketebo on 10/1/17.
//  Copyright © 2017 Krevalent. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    @IBAction func dismiss() {
        userDefaults.set(true, forKey: Literals.visitedBefore)
        dismiss(animated: true, completion: nil)
    }
}
