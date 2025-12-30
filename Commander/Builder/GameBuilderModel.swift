//
//  LevelModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import UIKit

struct GameBuilderModel {
    let enemyGraundPosition: [CGPoint]
    let enemyPerRound: [[EnemyRound]]
    let health: Int
    
    let enemyHealthMult: Int
    let appearence: AppearenceGameBuilderModel
    let startingMoney: Int
    let blockers: [BlockerModel]
    
    var rounds: Int {
        enemyPerRound.count
    }
    
    init(lvlModel: LevelModel) {
        enemyGraundPosition = Self.positions(lvlModel.level)
        enemyPerRound = .enemyList(lvlModel.level)
        health = Self.health(lvlModel.level)
        enemyHealthMult = 100
        self.startingMoney = 100
        self.blockers = .allData(lvlModel.level)
        appearence = .gameLevel(lvlModel.level) ?? .init()
    }
}

struct GameBuilderMiniModel {
    let health: Int
    
    let enemyHealthMult: Int
    
    let startingMoney: Int
    
    var rounds: Int
    
    init(data: GameBuilderModel) {
        health = data.health
        enemyHealthMult = data.enemyHealthMult
        startingMoney = data.startingMoney
        rounds = data.rounds
    }
}

fileprivate
extension GameBuilderModel {
    
    static func health(_ lvl: String) -> Int {
        switch lvl {
        default: 30
        }
    }
        
    static func positions(_ lvl: String) -> [CGPoint] {
        switch lvl {
        default:
            [
                .init(x: 0, y: 0), .init(x: 0.17, y: 0),
                .init(x: 0.17, y: 0.4), .init(x: 0.4, y: 0.4),
                .init(x: 0.4, y: 0.6), .init(x: 0.64, y: 0.6),
                .init(x: 0.64, y: 0.3), .init(x: 0.46, y: 0.3),
                .init(x: 0.46, y: 0.06), .init(x: 0.8, y: 0.06),
                .init(x: 0.8, y: 1)
            ]
        }
    }
}
