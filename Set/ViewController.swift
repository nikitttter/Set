//
//  ViewController.swift
//  Set
//
//  Created by Nikita Yakovlev on 11/11/2019.
//  Copyright © 2019 Nikita Yakovlev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var set = Set()
    var buttonsToCards = [Int : Int]()
    var newSet : Bool = false
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func getNewCards(_ sender: UIButton) {
        if buttonsToCards.count > 2 && set.cards.filter({$0.enableForGet}).count > 2 {
            getNewCards(3)
            updateViewFromModel()
        }
    }
    

    @IBAction func touchCard(_ sender: UIButton) {
        
        if let idButton = buttons.firstIndex(of: sender) {
            if let idcard = buttonsToCards[idButton] {
                let chekSet = set.chooseCard(identifier: idcard)
                updateViewFromModel(chekSet)
                if (!chekSet && newSet) {
                    getNewCards(3)
                    updateViewFromModel()
                }
                newSet = chekSet
            }
        }
    }
    
    @IBAction func createNewGame(_ sender: UIButton) {
        
        buttonsToCards.removeAll()
        set = Set()
        for button in buttons {
            button.setAttributedTitle(NSAttributedString(string: " ", attributes: nil), for: UIControl.State.normal)
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = 20.0
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white.cgColor
        }
        newSet = false
        getNewCards(12)
        updateViewFromModel()
    }
    
    func updateViewFromModel(_ hasSet : Bool = false) {
        
        for (btnId, cardId) in buttonsToCards{
            
            if let card = set.cards.first(where: {$0.identidier == cardId}) {
                if card.inSet && !card.isMached {
                    buttons[btnId].setAttributedTitle(NSAttributedString(string: " ", attributes: nil), for: UIControl.State.normal)
                    buttons[btnId].backgroundColor = UIColor.white
                    buttons[btnId].layer.borderColor = UIColor.white.cgColor
                    buttonsToCards[btnId] = nil

                }
            else if card.isMached {
                    if hasSet {
                        buttons[btnId].layer.borderColor = UIColor.green.cgColor
                    }
                    else {
                        if set.cards.filter({$0.isMached}).count == 3 {
                            buttons[btnId].layer.borderColor = UIColor.red.cgColor
                        }
                        else {
                            buttons[btnId].layer.borderColor = UIColor.yellow.cgColor
                        }
                    }
                    buttons[btnId].backgroundColor = UIColor.lightGray
            }
            else {
                let attributes: [NSAttributedString.Key : Any] = [
                    .strokeColor : card.color,
                    .strokeWidth : card.fill.rawValue < 0.0 ? 4 : -4,
                    .foregroundColor : card.color.withAlphaComponent(CGFloat.init(card.fill.rawValue)),
                    .font : UIFont.systemFont(ofSize: 32)
                ]
                
                buttons[btnId].setAttributedTitle(NSAttributedString(string: String(card.symbol.rawValue.repeatCharacter(card.numSymbols)), attributes: attributes), for: UIControl.State.normal)
                buttons[btnId].backgroundColor = UIColor.lightGray
                buttons[btnId].layer.borderColor = UIColor.black.cgColor
            }
        }
      }
    }
    
    func getNewCards(_ count : Int){
        updateViewFromModel()
        for _ in 1...count {
            if let cardId = set.getNewCardId() {
                if let ButtonId =  buttons.indices.filter({buttonsToCards[$0] == nil}).randomElement() {
                    buttonsToCards[ButtonId] = cardId
                }
            }
        }

    }
}

extension Character {
    func repeatCharacter(_ count : Int) -> String {
        var str = String(self)
        if count < 0 {
            return str
        }
        for _ in 1..<count {
            str.append(self)
        }
        return str
        
    }
}

