//
//  DataBaseService.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import Foundation

struct DataBaseService {
    fileprivate static var _db: DataBaseModel?
    static var db: DataBaseModel {
        get {
            let data = UserDefaults.standard.data(forKey: "db2")
            if let data = try? DataBaseModel.init(data) {
                return data
            }
            return .init()
        }
        set {
            UserDefaults.standard.setValue(try? newValue.encode() ?? .init(), forKey: "db2")
        }
    }
}

nonisolated
struct CloudDataBaseModel: Codable {
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
}
