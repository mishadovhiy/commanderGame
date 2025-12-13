//
//  LevelModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import Foundation

struct LevelModel: Codable {
    let level: Int
    var difficulty: Difficulty?
    var duration: GameDurationType?
}

extension LevelModel {
    static var test: Self {
        .init(level: 0, difficulty: .easy, duration: .normal)
    }
}
