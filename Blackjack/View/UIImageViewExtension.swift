//
//  UIImageViewExtension.swift
//  Card Animations
//
//  Created by Joshua Ramos on 10/6/17.
//  Copyright © 2017 Krevalent. All rights reserved.
//

import UIKit

extension UIImageView {
    func flipLeft(withNewImage image: UIImage) {
        UIView.transition(with: self, duration: 0.3, options: [.curveEaseInOut, .transitionFlipFromRight], animations: {
            self.image = image
        }, completion: nil)
    }
    func flipRight(withNewImage image: UIImage) {
        UIView.transition(with: self, duration: 0.3, options: [.curveEaseInOut, .transitionFlipFromLeft], animations: {
            self.image = image
        }, completion: nil)
    }
}
