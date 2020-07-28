//
//  DCViewController.swift
//  DCMemory
//
//  Created by Valeryia Beizer on 7/28/20.
//  Copyright © 2020 Valeryia Beizer. All rights reserved.
//

import UIKit

class DCViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  //  MARK: - Variables
  var model = CardModel()
  var cardArray = [Card]()
  var firstFlippedCardIndex: IndexPath?
  var timer: Timer?
  var milliseconds: Float = 30 * 1000
  let congrats = NSLocalizedString("Congrats", comment: "")
  let win = NSLocalizedString("Win", comment: "")
  let finish = NSLocalizedString("Finish", comment: "")
  let lose = NSLocalizedString("Lose", comment: "")
  let format = "%.2f"
  let identifier = "DCViewController"
  let cellIdentifier = "CardCell"
  
  //  MARK: - GUI Variables
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var timeRemaining: UILabel!
  
  //MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.cardArray = self.model.getCards()
    self.timer = Timer.scheduledTimer(timeInterval: 0.001,
                                      target: self,
                                      selector: #selector(self.timerElapsed),
                                      userInfo: nil,
                                      repeats: true)
    RunLoop.main.add(self.timer!, forMode: .common)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    SoundManager.playSound(.shuffle)
  }
  
  // MARK: - Actions
  @objc func timerElapsed() {
    self.milliseconds -= 1
    let seconds = String(format: self.format, self.milliseconds/1000)
    self.timeRemaining.text = NSLocalizedString("Time", comment: "") + seconds
    
    if self.milliseconds <= 0 {
      self.timer?.invalidate()
      self.timeRemaining.textColor = UIColor.red
      self.checkGameEnded()
    }
  }
  
  
  @IBAction func newGameButtonTapped(_ sender: Any) {
    let viewController = self.storyboard?.instantiateViewController(withIdentifier: self.identifier) as! DCViewController
    UIApplication.shared.keyWindow?.rootViewController = viewController
  }
  //  MARK: - Methods
  func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
    let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
    let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
    
    let cardOne = self.cardArray[firstFlippedCardIndex!.row]
    let cardTwo = self.cardArray[secondFlippedCardIndex.row]
    
    if cardOne.imageName == cardTwo.imageName {
      SoundManager.playSound(.match)
      cardOne.isMatched = true
      cardTwo.isMatched = true
      
      cardOneCell?.remove()
      cardTwoCell?.remove()
      self.checkGameEnded()
    } else {
      SoundManager.playSound(.nomatch)
      cardOne.isFlipped = false
      cardTwo.isFlipped = false
      
      cardOneCell?.flipBack()
      cardTwoCell?.flipBack()
    }
    if cardOneCell == nil {
      self.collectionView.reloadItems(at: [firstFlippedCardIndex!])
    }
    self.firstFlippedCardIndex = nil
  }
  
  func checkGameEnded() {
    var isWon = true
    for card in self.cardArray {
      if card.isMatched == false {
        isWon = false
        break
      }
    }
    
    var title = ""
    var message = ""
    
    if isWon == true {
      if self.milliseconds > 0 {
        self.timer?.invalidate()
      }
      title = self.congrats
      message = self.win
    } else {
      if self.milliseconds > 0 {
        return
      }   
      title = self.finish
      message = self.lose
    }
    self.showAlert(title, message)
  }
  
  func showAlert(_ title: String, _ message: String) {
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertViewController.addAction(alertAction)
    
    present(alertViewController, animated: true, completion: nil)
  }
  
  //  MARK: - UICollectionViewDelegate, UICollectionViewDataSource
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.cardArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath)
    let card = self.cardArray[indexPath.row]
    (cell as? CardCollectionViewCell)?.setCard(card)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if self.milliseconds <= 0 {
      return
    }
    let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
    let card = cardArray[indexPath.row]
    if card.isFlipped == false && card.isMatched == false {
      cell.flip()
      card.isFlipped = true
      SoundManager.playSound(.flip)
      
      if self.firstFlippedCardIndex == nil {
        self.firstFlippedCardIndex = indexPath
      } else {
        self.checkForMatches(indexPath)
      }
    }
  }
}
