//
//  DataBaseModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import Foundation

struct DataBaseModel: Codable {
    var upgradedWeapons: [WeaponType: [WeaponUpgradeType: Int]] = [:]
    var completedLevels: [LevelModel: GameProgress] = [
        .init(level: "11", levelPage: "1", difficulty: .easy, duration: .normal):.init(passedEnemyCount: 10, earnedMoney: 200, killedEnemies: 23, totalEnemies: 25),
        .init(level: "11", levelPage: "1", difficulty: .easy, duration: .infinityHealth):.init(passedEnemyCount: 10, earnedMoney: 200, killedEnemies: 25, totalEnemies: 25),
    ]
}
