//
//  Normalization.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/19/17.
//

import Foundation

enum Normalization: Int {
    case amd, nvidia, noNorm
    
    public init?(string: String) {
        switch string {
        case "AMD":
            self = .amd
        case "Nvidia" :
            self = .nvidia
        case "noNorm":
            self = .noNorm
        default: return nil
        }
    }
}
