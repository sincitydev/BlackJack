//
//  AppDelegate.swift
//  Blackjack
//
//  Created by Joshua Ramos on 9/29/17.
//  Copyright © 2017 Krevalent. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // This is called everytime the app launches just so we can have
        // an idea of what its like for the user when the first use the app
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        return true
    }
}

