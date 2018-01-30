//
//  CurrencyFormattedNumber.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/20/17.
//

import UIKit
import MiningPoolHub_Swift

class CurrencyFormattedNumber {
    let number: Double
    let currency: MphsCurrency
    
    init(for number: Double, in currency: MphsCurrency) {
        self.number = number
        self.currency = currency
    }
    
    var formattedNumber : String {
        //Detect crypto format
        var format = ""
        switch currency {
        case .btc, .ltc, .eth, .xmr : format = "%.8f"
        default: format = "%.2f"
        }
        
        let numberString = String(format: format, number)
    
        //Create denotation for currency
        var denotation = ""; var before = true;
        switch currency {
        case .usd, .cad: denotation = "$"
        case .eur: denotation = "€"
        case .gbp: denotation = "£"
        case .btc: denotation = "BTC"; before = false
        case .ltc: denotation = "LTC"; before = false
        case .eth: denotation = "ETH"; before = false
        case .xmr: denotation = "XMR"; before = false
        }
        
        return before ? denotation+" "+numberString : numberString+" "+denotation
    }
}
