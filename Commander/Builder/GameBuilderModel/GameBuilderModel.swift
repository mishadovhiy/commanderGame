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
    let prize: Int
    init(lvlModel: LevelModel) {
        enemyGraundPosition = Self.enemyGraund(lvlModel.level)
        enemyPerRound = .enemyList(lvlModel.level, page: lvlModel.levelPage)
        health = Self.health(lvlModel.level)
        enemyHealthMult = Int(lvlModel.level) ?? 1 * ((lvlModel.difficulty?.index ?? 0) + 1)
        self.startingMoney = 100
        self.blockers = .allData(lvlModel.level)
        appearence = .gameLevel(lvlModel.level) ?? .init()
        self.prize = Self.prize(lvlModel.level, page: lvlModel.levelPage, difficulty: lvlModel.difficulty ?? .easy)
    }
}

struct GameBuilderMiniModel {
    let health: Int
    
    let enemyHealthMult: Int
    
    let startingMoney: Int
    
    var rounds: Int
    let prize: Int
    init(data: GameBuilderModel) {
        health = data.health
        enemyHealthMult = data.enemyHealthMult
        startingMoney = data.startingMoney
        rounds = data.rounds
        prize = data.prize
    }
}

fileprivate
extension GameBuilderModel {
    static func prize(_ lvl: String, page: String, difficulty: Difficulty) -> Int {
        let level = Int(lvl) ?? 0
        let page = Int(page) ?? 0
        let pagePercent = Float(page) / Float(LevelPagesBuilder.maxPageCount)
        let lvlNumberInPage = level - page * LevelPagesBuilder.levelMultiplier(page: page)
        let stepLvl: Float = 50 * Float(lvlNumberInPage)
        let stepPage: Float = 100 * Float(pagePercent)
        return 350 + ((Int(stepLvl) + Int(stepPage)) * (difficulty.index + 1))
    }
    
    static func health(_ lvl: String) -> Int {
        switch lvl {
        default: 30
        }
    }
        
    static func enemyGraund(_ lvl: String) -> [CGPoint] {
        switch lvl {
        case "11":
            [
                .init(x: 0, y: 0.55), .init(x: 0.4, y: 0.55),
                .init(x: 0.4, y: 0.2), .init(x: 1, y: 0.2)
            ]
        case "12":
            [
                .init(x: 0, y: 0.2), .init(x: 0.2, y: 0.2),
                .init(x: 0.2, y: 0.6), .init(x: 0.6, y: 0.6),
                .init(x: 0.6, y: 0.2), .init(x: 1, y: 0.2)
            ]
        case "13", "407":
            [
                .init(x: 0.2, y: 1), .init(x: 0.2, y: 0.5),
                .init(x: 0.5, y: 0.5), .init(x:0.8, y: 0.5),
                .init(x: 0.8, y: 0)
            ]
        case "14":
            [
                .init(x: 0, y: 0.3), .init(x: 0.4, y: 0.3),
                .init(x: 0.4, y: 0.6), .init(x: 1, y: 0.6)
            ]
        case "15", "303":
            [
                .init(x: 0, y: 0.6), .init(x: 0.2, y: 0.6),
                .init(x: 0.2, y: 0.2), .init(x: 0.6, y: 0.2),
                .init(x: 0.6, y: 0.6), .init(x: 1, y: 0.6)
            ]
        case "16", "408":
            [
                .init(x: 0, y: 0.55), .init(x: 0.4, y: 0.55),
                .init(x: 0.4, y: 0.2), .init(x: 0.8, y: 0.2),
                .init(x: 0.8, y: 0.5), .init(x: 0.55, y: 0.5),
                .init(x: 0.55, y: 1)
            ]
        case "18", "409":
            [
                .init(x: 0, y: 0.6), .init(x: 0.2, y: 0.6),
                .init(x: 0.2, y: 0.1), .init(x: 0.8, y: 0.1),
                .init(x: 0.8, y: 0.6), .init(x: 0.4, y: 0.6),
                .init(x: 0.4, y: 1)
            ]
        case "19", "403":
            [
                .init(x: 0, y: 0.2), .init(x: 0.3, y: 0.2),
                .init(x: 0.3, y: 0.45), .init(x: 0.5, y: 0.45),
                .init(x: 0.5, y: 0.75), .init(x: 1, y: 0.75)
            ]
        case "402":
            [
                .init(x: 0.25, y: 0), .init(x: 0.25, y: 0.2),
                .init(x: 0.4, y: 0.2), .init(x: 0.8, y: 0.2),
                .init(x: 0.8, y: 0.5), .init(x: 0.6, y: 0.5),
                .init(x: 0.6, y: 0.76), .init(x: 0.4, y: 0.76),
                .init(x: 0.4, y: 0.5), .init(x: 0, y: 0.5)
            ]
        case "21", "404", "305":
            [
                .init(x: 0, y: 0.6), .init(x: 0.2, y: 0.6),
                .init(x: 0.2, y: 0.1), .init(x: 0.8, y: 0.1),
                .init(x: 0.8, y: 0.6), .init(x: 0.6, y: 0.6),
                .init(x: 0.6, y: 1)
            ]
        case "201":
            [
                .init(x: 0, y: 0.2), .init(x: 0.2, y: 0.2),
                .init(x: 0.2, y: 0.6), .init(x: 0.5, y: 0.6),
                .init(x: 0.5, y: 0.2), .init(x: 0.8, y: 0.2),
                .init(x: 0.8, y: 1)
            ]
        case "410", "304":
            [
                .init(x: 0, y: 0.2), .init(x: 0.2, y: 0.2),
                .init(x: 0.2, y: 0.6), .init(x: 0.6, y: 0.6),
                .init(x: 0.6, y: 0.2), .init(x: 1, y: 0.2)
            ]
        case "202", "306", "302", "211":
            [
                .init(x: 0.2, y:0), .init(x:0.2, y:0.55),
                .init(x: 0.2, y: 0.55), .init(x: 0.4, y: 0.55),
                .init(x: 0.4, y: 0.2), .init(x: 0.8, y: 0.2),
                .init(x: 0.8, y: 0.5), .init(x: 0.55, y: 0.5),
                .init(x: 0.55, y: 1)
            ]
        case "203", "406", "308":
            [
                .init(x: 0.2, y: 1), .init(x: 0.2, y: 0.5),
                .init(x: 0.5, y: 0.5), .init(x:0.8, y: 0.5),
                .init(x: 0.8, y: 0)
            ]
        case "204", "307":
            [
                .init(x: 0, y: 0.6), .init(x: 0.2, y: 0.6),
                .init(x: 0.2, y: 0.1), .init(x: 0.8, y: 0.1),
                .init(x: 0.8, y: 0.6), .init(x: 0.4, y: 0.6),
                .init(x: 0.4, y: 1)
            ]
        case "205", "411", "309":
            [
                .init(x: 0, y: 0.6), .init(x: 0.2, y: 0.6),
                .init(x: 0.2, y: 0.2), .init(x: 0.6, y: 0.2),
                .init(x: 0.6, y: 0.6), .init(x: 1, y: 0.6)
            ]
        case "206", "405", "310", "210", "17", "401":
            [
                .init(x: 0, y: 0.2), .init(x: 0.3, y: 0.2),
                .init(x: 0.3, y: 0.45), .init(x: 0.5, y: 0.45),
                .init(x: 0.5, y: 0.75), .init(x: 0.7, y: 0.75),
                .init(x: 0.7, y: 0.45), .init(x: 1, y: 0.45)
            ]
        case "207", "301":
            [
                .init(x: 0, y: 0.2), .init(x: 0.3, y: 0.2),
                .init(x: 0.3, y: 0.45), .init(x: 0.5, y: 0.45),
                .init(x: 0.5, y: 0.75), .init(x: 1, y: 0.75)
            ]
        case "208", "412", "311", "20":
            [
                .init(x: 0.25, y: 0), .init(x: 0.25, y: 0.2),
                .init(x: 0.4, y: 0.2), .init(x: 0.8, y: 0.2),
                .init(x: 0.8, y: 0.5), .init(x: 0.6, y: 0.5),
                .init(x: 0.6, y: 1)
            ]
        case "209": [
            .init(x: 0, y: 0.6), .init(x: 0.2, y: 0.6),
            .init(x: 0.2, y: 0.1), .init(x: 0.8, y: 0.1),
            .init(x: 0.8, y: 0.6), .init(x: 0.6, y: 0.6),
            .init(x: 0.6, y: 1)
        ]
        case "212":
            [
                .init(x: 0, y: 0.6), .init(x: 0.2, y: 0.6),
                .init(x: 0.2, y: 0.1), .init(x: 0.8, y: 0.1),
                .init(x: 0.8, y: 0.6), .init(x: 0.4, y: 0.6),
                .init(x: 0.4, y: 1)
            ]
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
