//
//  CardModel.swift
//  DCMemory
//
//  Created by Valeryia Beizer on 7/28/20.
//  Copyright © 2020 Valeryia Beizer. All rights reserved.
//

import Foundation

class CardModel {
    func getCards() -> [Card] {
        var generatedNumbersArray = [Int]()
        var generatedCardsArray = [Card]()
        
        while generatedNumbersArray.count < 6 {
            let randomNumber = arc4random_uniform(10) + 1
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                generatedNumbersArray.append(Int(randomNumber))
                
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardTwo)
            }
        }
        generatedCardsArray.shuffle()
        return generatedCardsArray
    }
}
