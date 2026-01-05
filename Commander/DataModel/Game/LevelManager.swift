//
//  LevelManager.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import Foundation

struct GameProgress: Codable {
    var passedEnemyCount: Int = 0
    var earnedMoney: Int = 0
    var killedEnemies: Int = 0
    var totalEnemies: Int = 0
    var health: Int = 0
    
    var currentRound: Int = 0
    var roundRepeated: Int = 0
    
    let pageDivider: CGFloat
    
    var moneyResult: Int {
        let divider = pageDivider * 1350
        let float = CGFloat(earnedMoney) / divider
        return Int(float)
    }
    
    var score: Int {
       Int(CGFloat(killedEnemies) / CGFloat(totalEnemies) * 100)
    }
}

struct LevelManager {
    let lvlModel: LevelModel
    let lvlBuilder: GameBuilderModel
    
#warning("calc current balance here")
    var progress: GameProgress
    
    init(_ lvl: LevelModel, dbProgress: GameProgress? = nil) {
        self.lvlModel = lvl
        self.lvlBuilder = .init(lvlModel: lvl)
        self.progress = dbProgress ?? .init(pageDivider: CGFloat(Int(lvl.levelPage) ?? 0) / CGFloat(LevelPagesBuilder.maxPageCount))
        print(lvlBuilder.enemyPerRound, " yhrtegrfesda ", progress.pageDivider)
        progress.totalEnemies = lvlBuilder.enemyPerRound.reduce(0, { result, element in
            return result + element.reduce(0, { partialResult, element2 in
                return partialResult + element2.count
            })
        })
        if lvl.duration == .singleLife {
            progress.health = 1
        } else {
            progress.health = lvlBuilder.health
        }
        progress.earnedMoney = Int(CGFloat(lvlBuilder.startingMoney) * (CGFloat(progress.pageDivider) * 1350))
    }
}


struct UncomplitedProgress: Codable {
    let gameProgress: GameProgress
    let weapons: [String: CGPoint]
    let weaponUpdates: [String: Difficulty?]
}
