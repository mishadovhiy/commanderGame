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
    
    var moneyResult: Int {
        let float = CGFloat(earnedMoney) / 20
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
    var currentRound: Int = 0
    var roundRepeated: Int = 0
    var progress: GameProgress = .init()
    var startTime: Date = .init()
    
    init(_ lvl: LevelModel) {
        self.lvlModel = lvl
        self.lvlBuilder = .init(lvlModel: lvl)
        print(lvlBuilder.enemyPerRound, " yhrtegrfesda ")
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
    }
    
    //hits -> damage
    //enemyKilled { //saves money
    //enemy passed
}
