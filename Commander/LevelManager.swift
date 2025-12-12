//
//  LevelManager.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import Foundation

struct LevelManager {
    let lvlModel: LevelModel
    let lvlBuilder: LvlBuilderModel
    
    var currentRound: Int = 0
    var passedEnemyCount: Int = 0
    var earnedMoney: Int = 0
    init(_ lvl: LevelModel) {
        self.lvlModel = lvl
        self.lvlBuilder = .init(lvlModel: lvl)
    }
    
    //hits -> damage
    //enemyKilled { //saves money
    //enemy passed
}
