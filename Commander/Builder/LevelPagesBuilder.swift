//
//  LevelsListBuilderModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import Foundation
import UIKit

struct LevelPagesBuilder: Equatable {
    let title: String
    let name: String
    let zoom: CGFloat
    let mapPosition: CGPoint
    let appearence: AppearenceGameBuilderModel
    let levels: [LevelListBuilder]
    
    struct LevelListBuilder: Equatable {
        let position: CGPoint
        let title: String
    }
}

extension [LevelPagesBuilder] {
    static var allData: Self {
        [
            .init(title: "1", name: "America", zoom: 1, mapPosition: .init(x: -0.08, y: -0.05), appearence: .init(backgroundColor: .dark, secondaryColor: .container, backgroundTextureName: "enemyGround", enemyGroundTextureName: "enemyGround"), levels: [
                .init(position:
                        .init(x: 0.08, y: 0.2),
                      title: "11"),
                .init(position:
                        .init(x: 0.25, y: 0.16),
                      title: "12"),
                .init(position:
                        .init(x: 0.41, y: 0.17),
                      title: "13"),
                .init(position:
                        .init(x: 0.63, y: 0.13),
                      title: "14"),
                .init(position:
                        .init(x: 0.59, y: 0.42),
                      title: "15"),
                .init(position:
                        .init(x: 0.69, y: 0.26),
                      title: "16"),
                .init(position:
                        .init(x: 0.85, y: 0.42),
                      title: "17"),
                .init(position:
                        .init(x: 0.93, y: 0.165),
                      title: "18"),
                .init(position:
                        .init(x: 0.95, y: 0.6),
                      title: "19"),
                .init(position:
                        .init(x: 0.7, y: 0.75),
                      title: "20"),
                .init(position:
                        .init(x: 0.36, y: 0.62),
                      title: "21")
            ]),
            .init(title: "2", name: "Africa", zoom: 1, mapPosition: .init(x: -0.4, y: -0.3), appearence: .init(backgroundColor: .white, secondaryColor: .blue, backgroundTextureName: "enemyGround", enemyGroundTextureName: "enemyGround"), levels: [
                .init(position:
                        .init(x: 0.12, y: 0.16),
                      title: "201"),
                .init(position:
                        .init(x: 0.08, y: 0.361),
                      title: "202"),
                .init(position:
                        .init(x: 0.24, y: 0.363),
                      title: "203"),
                .init(position:
                        .init(x: 0.15, y: 0.63),
                      title: "204"),
                .init(position:
                        .init(x: 0.46, y: 0.54),
                      title: "205"),
                .init(position:
                        .init(x: 0.4, y: 0.2),
                      title: "206"),
                .init(position:
                        .init(x: 0.66, y: 0.33),
                      title: "207"),
                .init(position:
                        .init(x: 0.83, y: 0.167),
                      title: "208"),
                .init(position:
                        .init(x: 0.824, y: 0.47),
                      title: "209"),
                .init(position:
                        .init(x: 0.9, y: 0.73),
                      title: "210"),
                .init(position:
                        .init(x: 0.65, y: 0.74),
                      title: "211"),
                .init(position:
                        .init(x: 0.3, y: 0.85),
                      title: "212")
            ]),//fix dots
            .init(title: "3", name: "Europe", zoom: 0.7, mapPosition: .init(x: -0.44, y: -0.03), appearence: .init(backgroundColor: .accent, secondaryColor: .dark, backgroundTextureName: "enemyGround", enemyGroundTextureName: "enemyGround"), levels: [
                .init(position:
                        .init(x: 0.2, y: 0.6),
                      title: "301"),
                .init(position:
                        .init(x: 0.23, y: 0.3),
                      title: "302"),
                .init(position:
                        .init(x: 0.46, y: 0.61),
                      title: "303"),
                .init(position:
                        .init(x: 0.4, y: 0.3),
                      title: "304"),
                .init(position:
                        .init(x: 0.5, y: 0.05),
                      title: "305"),
                .init(position:
                        .init(x: 0.6, y: 0.25),
                      title: "306"),
                .init(position:
                        .init(x: 0.86, y: 0.4),
                      title: "307"),
                .init(position:
                        .init(x: 0.84, y: 0.65),
                      title: "308"),
                .init(position:
                        .init(x: 0.67, y: 0.8),
                      title: "309"),
                .init(position:
                        .init(x: 0.59, y: 0.66),
                      title: "310"),
                .init(position:
                        .init(x: 0.67, y: 0.455),
                      title: "311")
            ]),
            .init(title: "4", name: "Australia", zoom: 1.6, mapPosition: .init(x: -0.76, y: -0.56), appearence: .init(backgroundColor: .red, secondaryColor: .orange, backgroundTextureName: "enemyGround", enemyGroundTextureName: "enemyGround"), levels: [//new dots
                .init(position:
                        .init(x: 0.12, y: 0.16),
                      title: "201"),
                .init(position:
                        .init(x: 0.08, y: 0.361),
                      title: "202"),
                .init(position:
                        .init(x: 0.24, y: 0.363),
                      title: "203"),
                .init(position:
                        .init(x: 0.15, y: 0.63),
                      title: "204"),
                .init(position:
                        .init(x: 0.46, y: 0.54),
                      title: "205"),
                .init(position:
                        .init(x: 0.4, y: 0.2),
                      title: "206"),
                .init(position:
                        .init(x: 0.66, y: 0.33),
                      title: "207"),
                .init(position:
                        .init(x: 0.83, y: 0.167),
                      title: "208"),
                .init(position:
                        .init(x: 0.824, y: 0.47),
                      title: "209"),
                .init(position:
                        .init(x: 0.9, y: 0.73),
                      title: "210"),
                .init(position:
                        .init(x: 0.65, y: 0.74),
                      title: "211"),
                .init(position:
                        .init(x: 0.3, y: 0.85),
                      title: "212")
            ]),

        ]
    }
}

enum LevelName: String {
    case one1
    case one2
    case one3
    case one4
    case one5
    case one6
    case one7
    case one8
    case one9
    case one10
    case one11
    case two1
    case two2
    case two3
    case two4
    case two5
    case two6
    case two7
    case two8
    case two9
    case two10
    case two11
    case two12
    case three1
    case three2
    case three3
    case three4
    case three5
    case three6
    case three7
    case three8
    case three9
    case three10
    case three11
    
    var title: String {
        "\(rawValue.numbers ?? 0)"
    }
}
