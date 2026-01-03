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
        switch self {
        case .pistol:
            80
        case .basuka:
            110
        case .granata:
            160
        }
    }
    
    var shootingDelay: TimeInterval {
        switch self {
        case .pistol:
            0.2
        case .basuka:
            1.2
        case .granata:
            0.5
        }
    }
    
    var textureSize: CGSize {
        switch self {
        case .pistol:
                .init(width: 20, height: 20)
        case .basuka:
                .init(width: 20, height: 20)
        case .granata:
                .init(width: 18, height: 30)
        }
    }
    
    var bulletSize: CGSize {
        .init(width: 8, height: 14)
    }
    
    var damage: Int {
        switch self {
        case .pistol:
            10
        case .granata:
            90
//        case .fire:
//            5
        case .basuka:
            450
//        case .flight:
//            40
//        case .stopper:
//            1
        }
    }
    
    var hasBullet: Bool {
        switch self {
        default: true
        }
    }
    //upgradePrice
    
    var upgradeStepPrice: Int {
        switch self {
        case .pistol: 50
        case .granata: 120
        case .basuka: 200
        }
    }
    
    var maxUpgradeLevel: Int {
        switch self {
        case .pistol: 8
        default: 25
        }
    }
    var maxIconsUpgrades: Int {
        switch self {
        case .pistol:
            2
        case .basuka:
            3
        case .granata:
            1
        }
    }
    func upgradedIconComponent(db upgrade: Int) -> Int {
        let max = maxIconsUpgrades
        let upgradePercent = CGFloat(upgrade) / CGFloat(maxUpgradeLevel)
        let percent = Int(upgradePercent * CGFloat(max))
        if percent == 0 {
            return 1
        }
        if percent >= maxIconsUpgrades {
            return maxIconsUpgrades
        }
        return percent
    }
}
