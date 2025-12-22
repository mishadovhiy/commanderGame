//
//  WeaponUpgradeType.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import Foundation

enum WeaponUpgradeType: String, Codable, CaseIterable {
    
    case attackPower
    case distance
    
    var title: String {
        rawValue.addingSpacesBeforeLargeLetters.capitalized
    }
    
    var iconName: String {
        switch self {
        case .attackPower:
                "weight"
        case .distance:
            "fire"
        }
    }
    
    var maxUpgradeDivider: CGFloat {
        switch self {
        case .attackPower:
            1
        case .distance:
            0.4
        }
    }
}
