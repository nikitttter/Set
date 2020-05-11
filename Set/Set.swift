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
    var ChoosedCards = [Card]()
    var numPenaltyCards = 0;
    var didSet = false
    //Extra
    var timeChoose : Date?
    var numАdditionalCardsOnTable = 0
    let coolTime : TimeInterval = 30.0
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
    
    func start() {
        timeChoose = Date.init()
        print(timeChoose!)
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
            
                return true
        }
        return false
    }
    
    func chooseCard (identifier : Int) -> Bool{
        
        let  ChoosedCard = cards.first{$0.identidier == identifier}
        guard ChoosedCard != nil else {
                 return false
        }
        didSet = false
        if !ChoosedCards.contains(where: {$0.identidier == ChoosedCard!.identidier}){
        
        if hasSet(ChoosedCards: ChoosedCards) {
            for card in ChoosedCards {
                card.inSet = true
                card.isMached = false
            }
            ChoosedCards.removeAll()
            didSet = true
           
        } else if ChoosedCards.count == 3 {
            for card in ChoosedCards {
                card.isMached = false
            }
            ChoosedCards.removeAll()
//            didSet = false
        }
            
        ChoosedCards.append(ChoosedCard!)
        ChoosedCard?.isMached = true

        } else if ChoosedCards.count < 3 {
            ChoosedCards.removeAll(where: {$0.identidier == ChoosedCard!.identidier})
            ChoosedCard!.isMached = false
        } else {
            return false
        }
        
        if hasSet(ChoosedCards: ChoosedCards) {
            changeScore(mode: 1)
            return true
        }
        //didSet = false
        if ChoosedCards.count == 3{
          changeScore(mode: 2)
        }
        return false
    }
    
    func getNewCardId() -> Int? {
        print("didSet = \(didSet)")
        if hasSet(ChoosedCards: ChoosedCards) {
        for card in ChoosedCards {
            card.inSet = true
            card.isMached = false
        }
        ChoosedCards.removeAll()
        didSet = true;
        }
        
        if timeChoose != nil  {
            if !didSet && numPenaltyCards >= 2 && findSet() == true {
                changeScore(mode: 3)
                numPenaltyCards = 0
            }
            else {
                numPenaltyCards += 1
            }
        }
        if ChoosedCards.count <= 1 && didSet == true && numPenaltyCards > 2 {
            didSet = false
            numPenaltyCards = 0
        }
        if let card = cards.filter({$0.enableForGet}).randomElement() {
          
            let cardId = card.identidier //!!!!!!!!!!!!!!!!
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
    /*
     mode = 1  - правильный Set
     mode = 2 - неправильный Set
     mode = 3 - штраф за доп. карты
     */
    func changeScore(mode : Int) {
        switch mode {
        case 1:
            if let currTime = timeChoose {
                    scope += abs(currTime.timeIntervalSinceNow) < coolTime ? 3 : 2
                    timeChoose = Date.init()
            }
        case 2:
            scope -= 2
        case 3:
            scope -= 1
        default:
            return
        }
        return
    }
    
    func findSet() -> Bool {//-> (Card, Card, Card)? {
        let openCards = cards.filter({$0.enableForGet == false && $0.inSet == false})
        
        for index1 in 0...(openCards.count-3) {
            for index2 in (index1+1)...(openCards.count-2) {
                for index3 in (index2+1)...(openCards.count-1) {
                    if hasSet(ChoosedCards: [openCards[index1],openCards[index2], openCards[index3]]) {
                        print("Есть SET")
                        return true
                    }
                }
            }
        }
       return false
    }
}
