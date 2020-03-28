//
//  Set.swift
//  Set
//
//  Created by Nikita Yakovlev on 12/11/2019.
//  Copyright © 2019 Nikita Yakovlev. All rights reserved.
//

import Foundation
import UIKit

class Set {
    var cards = [Card]()
    var numChoosedCards = 0
    var scope = 0
    init() {
        while cards.count != 81 {
            for _ in  1...3{
                _ = UIColor.SymbolColor.getNewColor()
                for _ in  1...3{
                    _ = Symbols.getNewValue()
                    for _ in 1...3{
                        _ = FillSorts.getNewValue()
                        for num in 1...3{
                        
                        cards.append(Card(color: UIColor.SymbolColor.getCurrentColor(), symbol: Symbols.currentValue, numOfSymbols: num, fill: FillSorts.currentValue))
                        }
                    }
                
                }
                
            }
        }
        cards.shuffle()
    }
    
    func hasSet(ChoosedCards : [Card]) -> Bool {
       for card in ChoosedCards {
           print(card.color.cgColor.hashValue)
       }
        if ( compareForSet(ChoosedCards[0].color.hashValue, ChoosedCards[1].color.hashValue, ChoosedCards[2].color.hashValue)
            &&
            compareForSet(ChoosedCards[0].numSymbols, ChoosedCards[1].numSymbols, ChoosedCards[2].numSymbols)
            &&
            compareForSet(ChoosedCards[0].symbol.hashValue, ChoosedCards[1].symbol.hashValue, ChoosedCards[2].symbol.hashValue)
            &&
            compareForSet(ChoosedCards[0].fill.hashValue, ChoosedCards[1].fill.hashValue, ChoosedCards[2].fill.hashValue)) {
            
                for card in ChoosedCards {
                        card.inSet = true
                }
                return true
            
        }
        
        return false
        
    }
    
    func chooseCard (identifier : Int) -> Bool{
        let  ChoosedCard = cards.first{$0.identidier == identifier}
        guard ChoosedCard != nil else {
            return false
        }
        if ChoosedCard!.isMached {
            ChoosedCard!.isMached = false
            numChoosedCards -= 1
        } else {
            ChoosedCard!.isMached = true
            numChoosedCards += 1
        }
        
        guard numChoosedCards == 3 else {
            return false
        }
        
        let cardsMatched = cards.filter({$0.isMached})
        
        if hasSet(ChoosedCards: cardsMatched) {
            scope += 1
            numChoosedCards = 0
            print("scope = \(scope)")
            for card in cardsMatched {
                       card.isMached = false
            }
            return true
        }
               
        return false
        
    }
    
    func getNewCardId() -> Int? {

        if let card = cards.filter({$0.enableForGet}).randomElement() {
            let cardId = card.identidier
            card.enableForGet = false
           return cardId
        }
        return nil
    }

    func compareForSet(_ property1 : Int, _ property2: Int, _ property3: Int) -> Bool {
        
        if (property1 == property2 && property2 == property3)
           ||
           (property1 != property2 && property1 != property2 && property2 != property3) {
            return true
        }
   
        return false
        
    }
}
