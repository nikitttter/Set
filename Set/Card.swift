//
//  Card.swift
//  Set
//
//  Created by Nikita Yakovlev on 12/11/2019.
//  Copyright © 2019 Nikita Yakovlev. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    struct SymbolColor {
        
        private static var counter = 0
        static func getNewColor() -> UIColor {
            switch counter {
            case 0:
                counter += 1
                return UIColor.red
            case 1:
                counter += 1
                return UIColor.green
            case 2:
                counter = 0
                return UIColor.yellow
            default:
                return UIColor.red
            }
        }
        static func getCurrentColor() -> UIColor {
            let temp = getNewColor()
            counter = counter == 0 ? 2 : counter-1
            return temp
        }
    }
}

enum Symbols: Character {
    case circle = "●"
    case square = "■"
    case triangle = "▲"
    
    static var currentValue : Symbols = .circle
    static func getNewValue() -> Symbols{
        switch currentValue {
        case  Symbols.circle :
            currentValue = Symbols.square
        case  Symbols.square :
            currentValue = Symbols.triangle
        case  Symbols.triangle :
            currentValue = Symbols.circle
        }
        return currentValue
    }
}

enum FillSorts: Float {
    case hatch = 0.15
    case empty = 0.0
    case full = 1.0
    
    static var currentValue : FillSorts = .hatch
    static func getNewValue() -> FillSorts{
        switch currentValue {
        case  FillSorts.hatch :
            currentValue = FillSorts.empty
        case  FillSorts.empty :
            currentValue = FillSorts.full
        case  FillSorts.full :
            currentValue = FillSorts.hatch
        }
        return currentValue
    }
}

class Card {
    
    static var identifierFactory = 0
    static func getUniqieIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    var isMached: Bool = false
    var inSet: Bool = false
    let color: UIColor
    let symbol : Symbols
    let numSymbols : Int
    let fill : FillSorts
    let identidier : Int
    var enableForGet : Bool = true
    init(color: UIColor, symbol: Symbols, numOfSymbols: Int, fill : FillSorts) {
        self.color = color
        self.symbol = symbol
        self.numSymbols = numOfSymbols
        self.fill = fill
        self.identidier = Card.getUniqieIdentifier()
    }
}


