//
//  WeaponType.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import Foundation

enum WeaponType: String, CaseIterable {
    case fire
    case basuka
    case flight
    case stopper
    case pistol
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
        case .pistol:
            15
        case .granata:
            15
        }
    }
    //upgradePrice
    
    var upgradeStepPrice: Int {
        switch self {
        default: 50
        }
    }
}
