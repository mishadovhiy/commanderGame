//
//  DataBaseModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import Foundation

struct DataBaseModel: Codable {
    private var _upgradedWeaponsssss: [WeaponType: [WeaponUpgradeType: Int]]? = [:]
    
    var upgradedWeapons: [WeaponType: [WeaponUpgradeType: Int]] {
        get {
            _upgradedWeaponsssss ?? [:]
        }
        set {
            _upgradedWeaponsssss = newValue
        }
    }
    var completedLevels: [LevelModel: GameProgress] = [:]
//    [
//        .init(level: "11", levelPage: "1", difficulty: .easy, duration: .infinityRounds):
//                .init(passedEnemyCount: 0, earnedMoney: 100, killedEnemies: 100, totalEnemies: 100, health: 30, currentRound: 50, roundRepeated: 0, pageDivider: 0.25),
//        .init(level: "12", levelPage: "1", difficulty: .easy, duration: .infinityRounds):
//                .init(passedEnemyCount: 0, earnedMoney: 100, killedEnemies: 100, totalEnemies: 100, health: 30, currentRound: 50, roundRepeated: 0, pageDivider: 0.25),
//        .init(level: "12", levelPage: "1", difficulty: .hard, duration: .infinityRounds):
//                .init(passedEnemyCount: 0, earnedMoney: 100, killedEnemies: 100, totalEnemies: 100, health: 30, currentRound: 50, roundRepeated: 0, pageDivider: 0.25)
//    ]
    
    private var _progress: [LevelModel: UncomplitedProgress]? = [:]
    var progress: [LevelModel: UncomplitedProgress] {
        get {
            _progress ?? [:]
        }
        set {
            _progress = newValue
        }
    }
    
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
                
                
                enum CodingKeys: String, CaseIterable, CodingKey {
                    case gameSound
                    case music
                    case menu
                }
            }
        }
    }
}
