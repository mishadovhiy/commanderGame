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
    static func numberOfRounds(_ lvl: Int, page: Int) -> Int {
        let initialValue: Int
        switch lvl {
        default:
            initialValue = 30
        }
        let initial = initialValue + (page * 4)
        return initial + (Int(Float(initial) * 0.5) * page - 1)
    }
    
    static func enemyList(_ lvl: String, page: String) -> Self {
        let level = Int(lvl) ?? 0
        let page = Int(page) ?? 0
        let roundCount: Range<Int> = 0..<numberOfRounds(level, page: page)
        let maxHealth = EnemyType.allCases.sorted(by: {$0.health >= $1.health}).first?.health ?? 0
        
        let pagePercent = Float(page) / Float(LevelPagesBuilder.maxPageCount)
        let lvlNumberInPage = level - page * LevelPagesBuilder.levelMultiplier(page: page)
        let lvlPercent = (Float(lvlNumberInPage) / Float(LevelPagesBuilder.levelCount(per: page))).closesPercent
        let enemiesPerPage = EnemyType.allCases.filter({
            let healthPercent = Float($0.health) / Float(maxHealth)
            return healthPercent.closesPercent <= pagePercent
        }).sorted(by: {
            $0.health <= $1.health
        })
        
        let enemies = enemiesPerPage.filter({
            let healthPercent = Float($0.health) / Float(enemiesPerPage.last?.health ?? 0)
            return healthPercent.closesPercent <= lvlPercent
        }).sorted(by: {
            $0.health <= $1.health
        })
        print(lvlPercent, " htegrfsdsa ", lvlPercent)
        print(lvl, " threggfeljfdsKDFS ", page, " hgjhjghjgdcsbhjxczhjbcbhjdfsbnv ")
        return roundCount.compactMap { i in
            let count = 15 + page + Int(lvlPercent * 10)
            let roundPercent = (Float(i) / Float(roundCount.upperBound)).closesPercent
            let enemies = enemies.filter({
                let healthPercent = Float($0.health) / Float(enemies.last?.health ?? 0)
                return healthPercent.closesPercent <= roundPercent

            })

            return enemies.compactMap({
                .init(type: $0, count: count / enemies.count)
            })
        }
//        return (0..<10).compactMap({ _ in
//            EnemyType.allCases.sorted(by: {
//                $0.health <= $1.health
//            }).compactMap({
//                .init(type: $0, count: 10)
//            })
//        })
    }
    
}
