//
//  DataBaseModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import Foundation

struct DataBaseModel: Codable {
    private var _upgradedWeapons: [WeaponType: [WeaponUpgradeType: Int]]? = [:]
    
    var upgradedWeapons: [WeaponType: [WeaponUpgradeType: Int]] {
        get {
            _upgradedWeapons ?? [:]
        }
        set {
            _upgradedWeapons = newValue
        }
    }
    var completedLevels: [LevelModel: GameProgress] = [
        .init(level: "11", levelPage: "1", difficulty: .easy, duration: .normal):.init(passedEnemyCount: 10, earnedMoney: 200, killedEnemies: 23, totalEnemies: 25),
        .init(level: "11", levelPage: "1", difficulty: .easy, duration: .infinityHealth):.init(passedEnemyCount: 10, earnedMoney: 200, killedEnemies: 25, totalEnemies: 25),
    ]
    
    var settings: Settings = .init()
}

extension DataBaseModel {
    struct Settings: Codable {
        var sound: Sound = .init()
        
        struct Sound: Codable {
            var voluem: Voluem = .init()
            
            nonisolated
            struct Voluem: Codable {
                var gameSound: CGFloat = 0.2
                var music: CGFloat = 0.2
                var menu: CGFloat = 0.2
                
                
                enum CodingKeys: String, CodingKey {
                    case gameSound
                    case music
                    case menu
                }
            }
        }
    }
}
