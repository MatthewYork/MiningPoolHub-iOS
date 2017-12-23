//
//  ContentType.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/19/17.
//

import Foundation

enum ContentType: Int {
    case auto, coin
    
    public init?(string: String) {
        switch string {
        case "Auto":
            self = .auto
        case "Coin" :
            self = .coin
        default: return nil
        }
    }
}
