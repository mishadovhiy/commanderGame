//
//  EnemyRound.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 30.12.2025.
//

import Foundation

extension GameBuilderModel {
    struct EnemyRound {
        let type: EnemyType
        let count: Int
    }
}

extension [[GameBuilderModel.EnemyRound]] {
    static func enemyList(_ lvl: String) -> Self {
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

}
