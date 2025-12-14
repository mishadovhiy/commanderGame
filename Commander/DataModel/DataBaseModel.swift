//
//  DataBaseModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import Foundation

struct DataBaseModel: Codable {
    var upgradedWeapons: [WeaponType: [WeaponUpgradeType: Int]] = [:]
    
}
