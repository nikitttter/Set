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
        guard ChoosedCards.count == 3 else {
            return false
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
        
        var cardsMatched = cards.filter({$0.isMached})
    
        
        if ChoosedCard!.isMached && numChoosedCards < 3 {
            ChoosedCard!.isMached = false
            numChoosedCards -= 1
        }
        else if cardsMatched.count == 3 && !cardsMatched.contains(where: {$0.identidier == ChoosedCard!.identidier}){
            for card in cardsMatched {
                card.isMached = false
            }
            numChoosedCards -= 2
            ChoosedCard!.isMached = true
            
            return false
        }
        else if !cardsMatched.contains(where: {$0.identidier == ChoosedCard!.identidier}){
            ChoosedCard!.isMached = true
            numChoosedCards += 1
            cardsMatched.append(ChoosedCard!)
        }
        else if cardsMatched.filter({$0.inSet}).count == 3 {
            return true
        }
        
        guard numChoosedCards > 2 else {
            return false
        }
        
        if hasSet(ChoosedCards: cardsMatched) {
            scope += 1
            print("scope = \(scope)")
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
           (property1 != property2 && property1 != property3 && property2 != property3) {
            return true
        }
        return false
        
        
    }
    
    func unMatchCards() {
        for card in cards.filter({$0.isMached}) {
            card.isMached = false
        }
        numChoosedCards = 0
    }
}
