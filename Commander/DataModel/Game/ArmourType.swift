//
//  ArmourType.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import Foundation

enum ArmourType {
    case fire
    case basuka
    case flight
    case stopper
    case pistole
    case granata
    
    var damage: Int {
        switch self {
        case .fire:
            5
        case .basuka:
            70
        case .flight:
            40
        case .stopper:
            1
        case .pistole:
            15
        case .granata:
            15
        }
    }
    //upgradePrice
}
