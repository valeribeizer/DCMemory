//
//  CardCollectionViewCell.swift
//  DCMemory
//
//  Created by Valeryia Beizer on 7/28/20.
//  Copyright © 2020 Valeryia Beizer. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
  //  MARK: - Variables
  var card: Card?
  
  //  MARK: - GUI Variables
  @IBOutlet weak var frontImageView: UIImageView!
  @IBOutlet var backImageView: UIImageView!
  
  //    MARK: - Methods
  func setCard(_ card: Card) {
    if card.isMatched {
      self.backImageView.alpha = 0
      self.frontImageView.alpha = 0
      return
    } else {
      self.backImageView.alpha = 1
      self.frontImageView.alpha = 1
    }
    self.card = card
    self.frontImageView.image = UIImage(named: card.imageName)
    
    if card.isFlipped {
      UIView.transition(from: self.backImageView,
                        to: self.frontImageView,
                        duration: 0,
                        options: [.transitionFlipFromLeft, .showHideTransitionViews],
                        completion: nil)
    } else {
      UIView.transition(from: self.frontImageView,
                        to: self.backImageView,
                        duration: 0,
                        options: [.transitionFlipFromRight, .showHideTransitionViews],
                        completion: nil)
    }
  }
  
  func flip() {
    UIView.transition(from: self.backImageView,
                      to: self.frontImageView,
                      duration: 0.3,
                      options: [.transitionFlipFromLeft, .showHideTransitionViews],
                      completion: nil)
  }
  
  func flipBack() {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
      UIView.transition(from: self.frontImageView,
                        to: self.backImageView,
                        duration: 0.3,
                        options: [.transitionFlipFromRight, .showHideTransitionViews],
                        completion: nil)
    })
  }
  
  func remove() {
    self.backImageView.alpha = 0
    UIView.animate(withDuration: 0.3,
                   delay: 0.5,
                   options: .curveEaseOut,
                   animations: {
                    self.frontImageView.alpha = 0
    },
                   completion: nil)
  }
}
