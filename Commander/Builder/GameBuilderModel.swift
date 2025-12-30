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
    
    struct EnemyRound {
        let type: EnemyType
        let count: Int
    }
    
    init(lvlModel: LevelModel) {
        enemyGraundPosition = Self.positions(lvlModel.level)
        enemyPerRound = Self.enemyList(lvlModel.level)
        health = Self.health(lvlModel.level)
        enemyHealthMult = 100
        self.startingMoney = 100
        self.blockers = Self.blockers(lvlModel.level)
        appearence = Self.colors(lvlModel.level) ?? .init()
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
    
    struct BlockerModel {
        let type: BlockerType
        let position: CGPoint
        let sizeMultiplier: CGFloat
        
        init(type: BlockerType,
             position: CGPoint,
             sizeMultiplier: CGFloat = 1) {
            self.type = type
            self.position = position
            self.sizeMultiplier = sizeMultiplier
        }
    }
    
    enum BlockerType: String {
        case tree1, tree2, tree3, tree4, tree5
        case tree6, tree7, tree8, tree9, tree10
        case bags, oil, helicopter
        case rock1, rock2, rock3
        case box1, box2
        case house1, house2, house3
        
        var assetName: String {
            let folder = "decorations/"
            guard let number = rawValue.numbers,
                    number >= 1 else {
                return folder + rawValue
            }
            let numberStr = "\(number)"
            return folder + rawValue
                .replacingOccurrences(of: numberStr, with: "") + "/" + numberStr
        }
        
        var size: CGSize {
            switch self {
            case .tree1:
                    .init(width: 20, height: 20)
            default:
                    .init(width: 20, height: 5.4)
            }
        }
    }
}

fileprivate
extension GameBuilderModel {
    
    static func colors(_ lvl: String) -> AppearenceGameBuilderModel? {
        switch lvl {
        case "13":
            .init(backgroundColor: .red, secondaryColor: .orange)
        default: nil
        }
    }
    
    static func health(_ lvl: String) -> Int {
        switch lvl {
        default: 30
        }
    }
    
    static func blockers(_ lvl: String) -> [BlockerModel] {
        switch lvl {
        default: [
            .init(type: .tree1, position: .init(x: 0.2, y: 0.1)),
            .init(type: .tree1, position: .init(x: 0.5, y: 0.3))
        ]
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
