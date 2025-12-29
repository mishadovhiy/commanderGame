//
//  WeaponType.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import Foundation

enum WeaponType: String, Codable, CaseIterable {
//    case fire
    case pistol
    case basuka
//    case flight
//    case stopper
    case granata
    
    var distance: Int {
        100
    }
    
    var shootingDelay: TimeInterval {
        switch self {
        case .basuka:
            1.2
        case .pistol:
            0.2
        case .granata:
            0.5
        }
    }
    
    var damage: Int {
        switch self {
//        case .fire:
//            5
        case .basuka:
            70
//        case .flight:
//            40
//        case .stopper:
//            1
        case .pistol:
            15
        case .granata:
            40
        }
    }
    
    var hasBullet: Bool {
        switch self {
        case .granata: true
        default: false
        }
    }
    //upgradePrice
    
    var upgradeStepPrice: Int {
        switch self {
        default: 50
        }
    }
    
    var maxUpgradeLevel: Int {
        switch self {
        case .pistol: 8
        default: 25
        }
    }
}
