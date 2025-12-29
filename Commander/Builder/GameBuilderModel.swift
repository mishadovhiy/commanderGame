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
    
    let startingMoney: Int
    
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
        self.startingMoney = 100
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

extension GameBuilderModel {
    enum BlockerType {
        case tree1
    }
}

fileprivate
extension GameBuilderModel {
    
    static func health(_ lvl: String) -> Int {
        switch lvl {
        default: 30
        }
    }
    
    static func enemyList(_ lvl: String) -> [[EnemyRound]] {
        switch lvl {
        case "11":
            [
                    [.init(type: .soldeir, count: 15),
                     .init(type: .soldeir, count: 20)],
                    [.init(type: .soldeir, count: 20),
                        .init(type: .vehicle, count: 10),
                    ],
                    [.init(type: .soldeir, count: 2),
                     .init(type: .flight, count: 5),
                     .init(type: .tankMBT, count: 2),
                     .init(type: .vehicle, count: 10)]
                ]
        case "15":
            [
                    [.init(type: .soldeir, count: 15),
                     .init(type: .vehicle, count: 20)],
                    [.init(type: .soldeir, count: 20),
                        .init(type: .vehicle, count: 10),
                    ],
                    [.init(type: .tankMBT, count: 5),
                     .init(type: .flight, count: 10),
                     .init(type: .tankMBT, count: 15),
                     .init(type: .vehicle, count: 10)],
                    [.init(type: .soldeir, count: 5),
                     .init(type: .vehicle, count: 10),
                     .init(type: .soldeir, count: 15),
                     .init(type: .vehicle, count: 10)]
                ]
        default: [
                [.init(type: .soldeir, count: 15),
                 .init(type: .soldeir, count: 20)],
                [.init(type: .soldeir, count: 20),
                    .init(type: .vehicle, count: 10),
                ],
                [.init(type: .soldeir, count: 2),
                 .init(type: .flight, count: 5),
                 .init(type: .tankMBT, count: 2),
                 .init(type: .vehicle, count: 10)]
            ]
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
