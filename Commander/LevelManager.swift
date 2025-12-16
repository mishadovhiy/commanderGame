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
    
    var score: Int {
       Int(CGFloat(killedEnemies) / CGFloat(totalEnemies))
    }
}

struct LevelManager {
    let lvlModel: LevelModel
    let lvlBuilder: GameBuilderModel
    
#warning("calc current balance here")
    var currentRound: Int = 0
    var progress: GameProgress = .init()
    var startTime: Date = .init()
    
    init(_ lvl: LevelModel) {
        self.lvlModel = lvl
        self.lvlBuilder = .init(lvlModel: lvl)
        progress.totalEnemies = lvlBuilder.enemyPerRound.flatMap({$0}).count
    }
    
    //hits -> damage
    //enemyKilled { //saves money
    //enemy passed
}
