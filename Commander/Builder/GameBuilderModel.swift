//
//  LevelModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import Foundation

struct GameBuilderModel {
    let enemyGraundPosition: [CGPoint]
    let enemyPerRound: [[EnemyRound]]
    let health: Int
    
    let enemyHealthMult: Int
    
    var rounds: Int {
        enemyPerRound.count
    }
    
    struct EnemyRound {
        let type: EnemyType
        let count: Int
    }
    
    init(lvlModel: LevelModel) {
        enemyGraundPosition = Self.positions(lvlModel.level)
        enemyPerRound = Self.enemyList(lvlModel.level)
        health = 10
        enemyHealthMult = 100
    }
}

fileprivate
extension GameBuilderModel {
    
    static func health(_ lvl: Int) -> Int {
        switch lvl {
        default: 30
        }
    }
    
    static func enemyList(_ lvl: Int) -> [[EnemyRound]] {
        switch lvl {
        default: [
                [.init(type: .soldeir, count: 10),
                 .init(type: .vehicle, count: 10),
                 .init(type: .flight, count: 10),
                 .init(type: .tankMBT, count: 10),
                 .init(type: .soldeir, count: 10),
                 .init(type: .soldeir, count: 10)],
                [.init(type: .soldeir, count: 10),
                 .init(type: .vehicle, count: 10),
                 .init(type: .soldeir, count: 10),
                 .init(type: .flight, count: 10),
                 .init(type: .soldeir, count: 10),
                 .init(type: .tankMBT, count: 10)],
                [.init(type: .vehicle, count: 10),
                 .init(type: .flight, count: 10),
                 .init(type: .tankMBT, count: 10),
                 .init(type: .soldeir, count: 10),
                 .init(type: .soldeir, count: 10),
                 .init(type: .soldeir, count: 10)]
            ]
        }
    }
    
    static func positions(_ lvl: Int) -> [CGPoint] {
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
